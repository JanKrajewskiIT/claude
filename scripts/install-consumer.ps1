[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$TargetRepository,
    [switch]$GuidanceOnly
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$guidanceRoot = Split-Path $PSScriptRoot -Parent
$rulesRoot = Join-Path $guidanceRoot 'rules'
$defaultTargetRoot = Split-Path $guidanceRoot -Parent
$targetRoot = if ($TargetRepository) {
    [IO.Path]::GetFullPath($TargetRepository)
}
else {
    $defaultTargetRoot
}
$ruleScopes = Get-Content (Join-Path $rulesRoot 'rule-scopes.json') -Raw | ConvertFrom-Json
$tsxFrameworkRules = @('react-conventions', 'solidjs-conventions')
$generatedBlockStart = '<!-- BEGIN shared agent guidance: generated from .agents, do not edit -->'
$generatedBlockEnd = '<!-- END shared agent guidance -->'
$legacyGeneratedHeading = '# Shared Agent Guidance'
$clientSettingsFiles = @(
    '.claude/settings.json'
    '.codex/config.toml'
    '.cursor/cli.json'
    '.cursor/permissions.json'
    '.vscode/settings.json'
)
$generatedDirectories = @(
    '.claude/skills'
    '.claude/rules'
    '.codex/skills'
    '.cursor/rules'
    '.cursor/skills'
    '.github/skills'
    '.github/instructions'
)

function Write-Utf8File {
    param(
        [string]$File,
        [string]$Content
    )

    [IO.File]::WriteAllText($File, $Content, $utf8NoBom)
}

function Get-RuleFiles {
    @(Get-ChildItem $rulesRoot -Filter '*.md' -File | Where-Object { $_.Name -ne 'README.md' } | Sort-Object Name)
}

function Get-RuleScope {
    param([string]$RuleName)

    $entry = $ruleScopes.PSObject.Properties[$RuleName]
    if (-not $entry) {
        throw "Rule '$RuleName' has no entry in rules/rule-scopes.json."
    }

    [PSCustomObject]@{
        Globs = @($entry.Value.applyTo | Where-Object { $_ })
        Description = $entry.Value.description
    }
}

function Test-TrackedFile {
    param([string]$RelativePath)

    $trackedPaths = @(& git -C $targetRoot ls-files -- $RelativePath)
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to inspect Git tracking for '$RelativePath'."
    }

    $trackedPaths.Count -gt 0
}

function Sync-Skills {
    param([string]$DestinationRoot)

    if ($PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with skills from .agents')) {
        Assert-GeneratedDirectory -DestinationRoot $DestinationRoot
        if (Test-Path $DestinationRoot) {
            Remove-Item -LiteralPath $DestinationRoot -Recurse -Force
        }

        New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null

        foreach ($skill in @(Get-ChildItem (Join-Path $guidanceRoot 'skills') -Directory)) {
            $destination = Join-Path $DestinationRoot $skill.Name
            Copy-Item -Path $skill.FullName -Destination $destination -Recurse
        }
    }
}

function Assert-GeneratedDirectory {
    param([string]$DestinationRoot)

    $resolvedTarget = [IO.Path]::GetFullPath($DestinationRoot)
    $resolvedRepository = [IO.Path]::GetFullPath($targetRoot).TrimEnd([IO.Path]::DirectorySeparatorChar)
    $allowedTargets = @($generatedDirectories | ForEach-Object {
        [IO.Path]::GetFullPath((Join-Path $resolvedRepository $_))
    })
    if ($resolvedTarget -notin $allowedTargets) {
        throw "Refusing to replace a directory outside the generated guidance paths: $resolvedTarget"
    }

    $current = $resolvedTarget
    while (-not [string]::Equals($current, $resolvedRepository, [StringComparison]::OrdinalIgnoreCase)) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Refusing to replace guidance through a symbolic link or junction: $current"
            }
        }
        $current = Split-Path $current -Parent
        if (-not $current) {
            throw 'Generated guidance path did not resolve within its repository.'
        }
    }
}

function Sync-ClientFile {
    param(
        [string]$SourceFile,
        [string]$DestinationFile
    )

    if (-not $PSCmdlet.ShouldProcess($DestinationFile, "Replace with $SourceFile from .agents")) {
        return
    }

    $destinationDirectory = Split-Path $DestinationFile -Parent
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    $content = Get-Content (Join-Path $guidanceRoot $SourceFile) -Raw
    Write-Utf8File -File $DestinationFile -Content $content
}

function Reset-Directory {
    param([string]$DestinationRoot)

    Assert-GeneratedDirectory -DestinationRoot $DestinationRoot
    if (Test-Path $DestinationRoot) {
        Remove-Item -LiteralPath $DestinationRoot -Recurse -Force
    }

    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null
}

function Get-ClaudePathsFrontmatter {
    param([string[]]$Globs)

    $paths = @($Globs | ForEach-Object { "  - `"$_`"" }) -join "`r`n"
    "---`r`npaths:`r`n$paths`r`n---`r`n`r`n"
}

function Sync-ClaudeRules {
    param([string]$DestinationRoot)

    if (-not $PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with Claude rule adapters from .agents')) {
        return
    }

    Reset-Directory -DestinationRoot $DestinationRoot

    foreach ($rule in Get-RuleFiles) {
        $name = $rule.BaseName
        if ($name -in $tsxFrameworkRules) {
            continue
        }

        $scope = Get-RuleScope -RuleName $name
        $content = Get-Content $rule.FullName -Raw
        $adapter = if ($scope.Globs.Count -eq 0) {
            $content
        }
        else {
            (Get-ClaudePathsFrontmatter -Globs $scope.Globs) + $content
        }

        Write-Utf8File -File (Join-Path $DestinationRoot $rule.Name) -Content $adapter
    }

    $reactRules = Get-Content (Join-Path $rulesRoot 'react-conventions.md') -Raw
    $solidRules = Get-Content (Join-Path $rulesRoot 'solidjs-conventions.md') -Raw
    $frameworkGlobs = (Get-RuleScope -RuleName 'react-conventions').Globs
    $frameworkRules = @"
# TSX Framework Routing

- Determine whether the owning project and file use React or SolidJS from imports, dependencies, and repository configuration.
- Apply exactly one matching framework section.
- Do not apply React lifecycle, rerender, hook, or memoization assumptions to SolidJS.
- Do not apply SolidJS signal, owner, resource, or control-flow assumptions to React.

$reactRules

$solidRules
"@
    $frameworkAdapter = (Get-ClaudePathsFrontmatter -Globs $frameworkGlobs) + $frameworkRules
    Write-Utf8File -File (Join-Path $DestinationRoot 'tsx-framework-conventions.md') -Content $frameworkAdapter
}

function Sync-CopilotRules {
    param([string]$DestinationRoot)

    if (-not $PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with Copilot instruction adapters from .agents')) {
        return
    }

    Reset-Directory -DestinationRoot $DestinationRoot

    foreach ($rule in Get-RuleFiles) {
        $name = $rule.BaseName
        $scope = Get-RuleScope -RuleName $name
        $content = Get-Content $rule.FullName -Raw
        $frontmatter = if ($scope.Description) {
            "name: $name`r`ndescription: $($scope.Description)"
        }
        elseif ($scope.Globs.Count -eq 0) {
            "name: $name`r`ndescription: Shared $name guidance`r`napplyTo: `"**`""
        }
        else {
            "name: $name`r`ndescription: Shared $name guidance`r`napplyTo: `"$($scope.Globs -join ',')`""
        }

        $adapter = "---`r`n$frontmatter`r`n---`r`n`r`n$content"
        Write-Utf8File -File (Join-Path $DestinationRoot "$name.instructions.md") -Content $adapter
    }
}

function Sync-CursorRules {
    param([string]$DestinationRoot)

    if (-not $PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with Cursor rule adapters from .agents')) {
        return
    }

    Reset-Directory -DestinationRoot $DestinationRoot

    foreach ($rule in Get-RuleFiles) {
        $name = $rule.BaseName
        $scope = Get-RuleScope -RuleName $name
        $content = Get-Content $rule.FullName -Raw
        $frontmatter = if ($scope.Description) {
            "description: $($scope.Description)`r`nalwaysApply: false"
        }
        elseif ($scope.Globs.Count -eq 0) {
            'alwaysApply: true'
        }
        else {
            "globs: `"$($scope.Globs -join ',')`"`r`nalwaysApply: false"
        }

        $adapter = "---`r`n$frontmatter`r`n---`r`n`r`n$content"
        Write-Utf8File -File (Join-Path $DestinationRoot "$name.mdc") -Content $adapter
    }
}

function Get-SharedGuidance {
    $source = (Get-Content (Join-Path $guidanceRoot 'AGENTS.md') -Raw).Trim()
    [regex]::Replace($source, '`(rules|skills)/', '`.agents/$1/')
}

function Get-ClaudeGuidance {
    $guidance = [regex]::Replace((Get-SharedGuidance), '(?ms)^## Rules\r?\n.*?(?=^## |\z)', '')
    $installedRules = '- Shared rules load from `.claude/rules/`; path-scoped rules apply only to matching files.'
    $guidance.TrimEnd() + "`r`n`r`n## Installed Rules`r`n`r`n" + $installedRules
}

function Set-GeneratedBlock {
    param(
        [string]$File,
        [string]$Guidance
    )

    $block = "$generatedBlockStart`r`n$Guidance`r`n$generatedBlockEnd"
    $existing = if (Test-Path $File -PathType Leaf) { Get-Content $File -Raw } else { $null }

    if ([string]::IsNullOrWhiteSpace($existing)) {
        $content = "$block`r`n"
    }
    else {
        $pattern = [regex]::Escape($generatedBlockStart) + '(?s).*?' + [regex]::Escape($generatedBlockEnd)
        $match = [regex]::Match($existing, $pattern)
        if ($match.Success) {
            $content = $existing.Substring(0, $match.Index) + $block + $existing.Substring($match.Index + $match.Length)
        }
        elseif ($existing.TrimStart().StartsWith($legacyGeneratedHeading)) {
            $content = "$block`r`n"
        }
        else {
            $content = $existing.TrimEnd() + "`r`n`r`n$block`r`n"
        }
    }

    if ($PSCmdlet.ShouldProcess($File, 'Update the generated shared guidance block')) {
        New-Item -ItemType Directory -Path (Split-Path $File -Parent) -Force | Out-Null
        Write-Utf8File -File $File -Content $content
    }
}

function Remove-LegacyClaudeInstructions {
    $file = Join-Path $targetRoot 'CLAUDE.md'
    if (-not (Test-Path $file -PathType Leaf)) {
        return
    }

    $content = Get-Content $file -Raw
    if ($null -eq $content -or -not $content.TrimStart().StartsWith($legacyGeneratedHeading)) {
        return
    }

    if ($PSCmdlet.ShouldProcess($file, 'Remove legacy generated Claude instructions')) {
        Remove-Item $file -Force
    }
}

function Update-GitIgnore {
    $gitIgnorePath = Join-Path $targetRoot '.gitignore'
    $existingLines = if (Test-Path $gitIgnorePath) {
        @(Get-Content $gitIgnorePath)
    }
    else {
        @()
    }
    $obsoleteEntries = @(
        '/CLAUDE.md'
        '/AGENTS.md'
        '/.claude/CLAUDE.md'
        '/.claude/rules/shared-agents/'
        '/.cursor/rules/shared-agents/'
        '/.github/instructions/shared-agents/'
        '# Generated agent skill copies'
    ) + @($projectOwnedSettingsFiles | ForEach-Object { "/$_" })
    $retainedLines = @($existingLines | Where-Object { $_ -notin $obsoleteEntries })
    $generatedEntries = @($generatedDirectories | ForEach-Object { "/$_/" }) + @($managedSettingsFiles | ForEach-Object { "/$_" })
    $missingEntries = @($generatedEntries | Where-Object { $_ -notin $retainedLines })

    if ($missingEntries.Count -eq 0 -and $retainedLines.Count -eq $existingLines.Count) {
        return
    }

    if ($PSCmdlet.ShouldProcess($gitIgnorePath, 'Ignore generated agent customizations')) {
        $linesToAdd = @($retainedLines)
        if ($missingEntries.Count -gt 0) {
            if ($linesToAdd.Count -gt 0 -and $linesToAdd[-1] -ne '') {
                $linesToAdd += ''
            }

            if ('# Generated agent customizations' -notin $linesToAdd) {
                $linesToAdd += '# Generated agent customizations'
            }
            $linesToAdd += $missingEntries
        }

        $gitIgnoreContent = ($linesToAdd -join [Environment]::NewLine) + [Environment]::NewLine
        Write-Utf8File -File $gitIgnorePath -Content $gitIgnoreContent
    }
}

function Remove-GeneratedPathsFromGitIndex {
    if (-not $PSCmdlet.ShouldProcess($targetRoot, 'Stop tracking generated agent files')) {
        return
    }

    $generatedPaths = @($generatedDirectories) + @($managedSettingsFiles)
    & git -C $targetRoot rm -r --cached --ignore-unmatch -f -- $generatedPaths
    if ($LASTEXITCODE -ne 0) {
        throw 'Failed to remove generated agent files from the Git index.'
    }
}

if (-not (Test-Path (Join-Path $targetRoot '.git'))) {
    throw "Target is not a Git repository: $targetRoot"
}

if ([IO.Path]::GetFullPath((Join-Path $targetRoot '.agents')) -ne [IO.Path]::GetFullPath($guidanceRoot)) {
    throw "Run this script from the target repository's '.agents/scripts' directory or specify its parent with -TargetRepository."
}

$managedSettingsFiles = @()
$projectOwnedSettingsFiles = @()
if (-not $GuidanceOnly) {
    foreach ($settingsFile in $clientSettingsFiles) {
        if (Test-TrackedFile -RelativePath $settingsFile) {
            $projectOwnedSettingsFiles += $settingsFile
            Write-Warning "Skipping tracked project file '$settingsFile'. Merge the shared settings from .agents/$settingsFile manually if needed."
        }
        else {
            $managedSettingsFiles += $settingsFile
        }
    }
}

Set-GeneratedBlock -File (Join-Path $targetRoot 'AGENTS.md') -Guidance (Get-SharedGuidance)
Set-GeneratedBlock -File (Join-Path $targetRoot '.claude\CLAUDE.md') -Guidance (Get-ClaudeGuidance)
if (-not $GuidanceOnly) {
    Remove-LegacyClaudeInstructions
    Update-GitIgnore
    foreach ($settingsFile in $managedSettingsFiles) {
        Sync-ClientFile -SourceFile $settingsFile -DestinationFile (Join-Path $targetRoot $settingsFile)
    }
}
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.claude\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.codex\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.cursor\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.github\skills')
Sync-ClaudeRules -DestinationRoot (Join-Path $targetRoot '.claude\rules')
Sync-CursorRules -DestinationRoot (Join-Path $targetRoot '.cursor\rules')
Sync-CopilotRules -DestinationRoot (Join-Path $targetRoot '.github\instructions')
if (-not $GuidanceOnly) {
    Remove-GeneratedPathsFromGitIndex
}
