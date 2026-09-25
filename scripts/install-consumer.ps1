[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$TargetRepository
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$guidanceRoot = Split-Path $PSScriptRoot -Parent
$defaultTargetRoot = Split-Path $guidanceRoot -Parent
$targetRoot = if ($TargetRepository) {
    [IO.Path]::GetFullPath($TargetRepository)
}
else {
    $defaultTargetRoot
}

function Write-Utf8File {
    param(
        [string]$File,
        [string]$Content
    )

    [IO.File]::WriteAllText($File, $Content, $utf8NoBom)
}

function Sync-Skills {
    param([string]$DestinationRoot)

    if ($PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with skills from .agents')) {
        if (Test-Path $DestinationRoot) {
            Remove-Item $DestinationRoot -Recurse -Force
        }

        New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null

        foreach ($skill in @(Get-ChildItem (Join-Path $guidanceRoot 'skills') -Directory)) {
            $destination = Join-Path $DestinationRoot $skill.Name
            Copy-Item -Path $skill.FullName -Destination $destination -Recurse
        }
    }
}

function Sync-ClaudeSettings {
    param([string]$DestinationFile)

    if (-not $PSCmdlet.ShouldProcess($DestinationFile, 'Replace with Claude settings from .agents')) {
        return
    }

    $destinationDirectory = Split-Path $DestinationFile -Parent
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    $content = Get-Content (Join-Path $guidanceRoot '.claude\settings.json') -Raw
    Write-Utf8File -File $DestinationFile -Content $content
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

function Get-RuleApplyTo {
    param([string]$RuleName)

    switch ($RuleName) {
        'css-modules-conventions' { '**/*.module.css,**/*.module.scss,**/*.module.sass,**/*.module.less' }
        'dotnet-conventions' { '**/*.cs,**/*.csproj,**/*.fs,**/*.fsproj,**/*.sln,**/*.slnx' }
        'dotnet-error-handling' { '**/*.cs,**/*.csproj,**/*.fs,**/*.fsproj' }
        'frontend-accessibility' { '**/*.html,**/*.htm,**/*.tsx,**/*.jsx,**/*.vue,**/*.svelte,**/*.razor' }
        'react-conventions' { '**/*.tsx,**/*.jsx' }
        'solidjs-conventions' { '**/*.tsx,**/*.jsx' }
        'tsx-component-conventions' { '**/*.tsx,**/*.jsx' }
        'typescript-conventions' { '**/*.ts,**/*.tsx,**/*.mts,**/*.cts' }
        default { '**' }
    }
}

function Sync-ClaudeRules {
    param([string]$DestinationRoot)

    if (-not $PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with Claude rule adapters from .agents')) {
        return
    }

    if (Test-Path $DestinationRoot) {
        Remove-Item $DestinationRoot -Recurse -Force
    }

    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null

    foreach ($rule in @(Get-ChildItem (Join-Path $guidanceRoot 'rules') -Filter '*.md' -File)) {
        if ($rule.Name -eq 'README.md') {
            continue
        }

        $name = [IO.Path]::GetFileNameWithoutExtension($rule.Name)
        if ($name -in @('react-conventions', 'solidjs-conventions')) {
            continue
        }

        $paths = @((Get-RuleApplyTo -RuleName $name) -split ',' | ForEach-Object { "  - `"$($_)`"" }) -join "`r`n"
        $content = Get-Content $rule.FullName -Raw
        $adapter = "---`r`npaths:`r`n$paths`r`n---`r`n`r`n$content"
        Write-Utf8File -File (Join-Path $DestinationRoot $rule.Name) -Content $adapter
    }

    $reactRules = Get-Content (Join-Path $guidanceRoot 'rules\react-conventions.md') -Raw
    $solidRules = Get-Content (Join-Path $guidanceRoot 'rules\solidjs-conventions.md') -Raw
    $frameworkAdapter = @"
---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
---

# TSX Framework Routing

- Determine whether the owning project and file use React or SolidJS from imports, dependencies, and repository configuration.
- Apply exactly one matching framework section.
- Do not apply React lifecycle, rerender, hook, or memoization assumptions to SolidJS.
- Do not apply SolidJS signal, owner, resource, or control-flow assumptions to React.

$reactRules

$solidRules
"@
    Write-Utf8File -File (Join-Path $DestinationRoot 'tsx-framework-conventions.md') -Content $frameworkAdapter
}

function Sync-CopilotRules {
    param([string]$DestinationRoot)

    if (-not $PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with Copilot instruction adapters from .agents')) {
        return
    }

    if (Test-Path $DestinationRoot) {
        Remove-Item $DestinationRoot -Recurse -Force
    }

    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null

    foreach ($rule in @(Get-ChildItem (Join-Path $guidanceRoot 'rules') -Filter '*.md' -File)) {
        if ($rule.Name -eq 'README.md') {
            continue
        }

        $name = [IO.Path]::GetFileNameWithoutExtension($rule.Name)
        $content = Get-Content $rule.FullName -Raw
        if ($name -in @('react-conventions', 'solidjs-conventions')) {
            $framework = if ($name -eq 'react-conventions') { 'React' } else { 'SolidJS' }
            $adapter = "---`r`nname: $name`r`ndescription: $framework conventions. Apply when working in a $framework application.`r`n---`r`n`r`n$content"
        }
        else {
            $applyTo = Get-RuleApplyTo -RuleName $name
            $adapter = "---`r`nname: $name`r`ndescription: Shared $name guidance`r`napplyTo: `"$applyTo`"`r`n---`r`n`r`n$content"
        }

        Write-Utf8File -File (Join-Path $DestinationRoot "$name.instructions.md") -Content $adapter
    }
}

function Sync-CursorRules {
    param([string]$DestinationRoot)

    if (-not $PSCmdlet.ShouldProcess($DestinationRoot, 'Replace with Cursor rule adapters from .agents')) {
        return
    }

    if (Test-Path $DestinationRoot) {
        Remove-Item $DestinationRoot -Recurse -Force
    }

    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null

    foreach ($rule in @(Get-ChildItem (Join-Path $guidanceRoot 'rules') -Filter '*.md' -File)) {
        if ($rule.Name -eq 'README.md') {
            continue
        }

        $name = [IO.Path]::GetFileNameWithoutExtension($rule.Name)
        $content = Get-Content $rule.FullName -Raw
        if ($name -in @('react-conventions', 'solidjs-conventions')) {
            $framework = if ($name -eq 'react-conventions') { 'React' } else { 'SolidJS' }
            $frontmatter = "description: $framework conventions. Apply when working in a $framework application.`r`nalwaysApply: false"
        }
        else {
            $globs = Get-RuleApplyTo -RuleName $name
            $frontmatter = if ($globs -eq '**') {
                'alwaysApply: true'
            }
            else {
                "globs: `"$globs`"`r`nalwaysApply: false"
            }
        }

        $adapter = "---`r`n$frontmatter`r`n---`r`n`r`n$content"
        Write-Utf8File -File (Join-Path $DestinationRoot "$name.mdc") -Content $adapter
    }
}

function Get-CombinedRuleGuidance {
    $sections = @('# Shared Agent Guidance')

    foreach ($rule in @(Get-ChildItem (Join-Path $guidanceRoot 'rules') -Filter '*.md' -File | Where-Object { $_.Name -ne 'README.md' } | Sort-Object Name)) {
        $sections += (Get-Content $rule.FullName -Raw).Trim()
    }

    ($sections -join "`r`n`r`n") + "`r`n"
}

function Update-AgentInstructions {
    param([string]$File)

    $content = Get-CombinedRuleGuidance

    if ($PSCmdlet.ShouldProcess($File, 'Replace repository agent instructions')) {
        Write-Utf8File -File $File -Content $content
    }
}

function Update-ClaudeInstructions {
    param([string]$File)

    if ($PSCmdlet.ShouldProcess($File, 'Replace Claude repository instructions')) {
        $destinationDirectory = Split-Path $File -Parent
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
        Write-Utf8File -File $File -Content (Get-CombinedRuleGuidance)
    }
}

function Add-GeneratedPathsToGitIgnore {
    $gitIgnorePath = Join-Path $targetRoot '.gitignore'
    $existingLines = if (Test-Path $gitIgnorePath) {
        @(Get-Content $gitIgnorePath)
    }
    else {
        @()
    }
    $obsoleteEntries = @(
        '/CLAUDE.md'
        '/.claude/rules/shared-agents/'
        '/.cursor/rules/shared-agents/'
        '/.github/instructions/shared-agents/'
        '# Generated agent skill copies'
    )
    $retainedLines = @($existingLines | Where-Object { $_ -notin $obsoleteEntries })
    $generatedEntries = @(
        '/AGENTS.md'
        '/.claude/CLAUDE.md'
        '/.claude/settings.json'
        '/.claude/skills/'
        '/.claude/rules/'
        '/.codex/config.toml'
        '/.codex/skills/'
        '/.cursor/cli.json'
        '/.cursor/permissions.json'
        '/.cursor/rules/'
        '/.cursor/skills/'
        '/.github/skills/'
        '/.github/instructions/'
        '/.vscode/settings.json'
    )
    $missingEntries = @($generatedEntries | Where-Object { $_ -notin $retainedLines })

    if ($missingEntries.Count -eq 0 -and $retainedLines.Count -eq $existingLines.Count) {
        return
    }

    if ($PSCmdlet.ShouldProcess($gitIgnorePath, 'Ignore generated agent customizations')) {
        $linesToAdd = @($retainedLines)
        if ($linesToAdd.Count -gt 0 -and $linesToAdd[-1] -ne '') {
            $linesToAdd += ''
        }

        if ('# Generated agent customizations' -notin $linesToAdd) {
            $linesToAdd += '# Generated agent customizations'
        }
        $linesToAdd += $missingEntries
        $gitIgnoreContent = ($linesToAdd -join [Environment]::NewLine) + [Environment]::NewLine
        Write-Utf8File -File $gitIgnorePath -Content $gitIgnoreContent
    }
}

function Remove-GeneratedPathsFromGitIndex {
    if (-not $PSCmdlet.ShouldProcess($targetRoot, 'Stop tracking generated agent files')) {
        return
    }

    & git -C $targetRoot rm -r --cached --ignore-unmatch -f -- AGENTS.md CLAUDE.md .claude/CLAUDE.md .claude/settings.json .claude/skills .claude/rules .codex/config.toml .codex/skills .cursor/cli.json .cursor/permissions.json .cursor/rules .cursor/skills .github/skills .github/instructions .vscode/settings.json
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

Update-AgentInstructions -File (Join-Path $targetRoot 'AGENTS.md')
if (Test-Path (Join-Path $targetRoot 'CLAUDE.md')) {
    Remove-Item (Join-Path $targetRoot 'CLAUDE.md') -Force
}
Update-ClaudeInstructions -File (Join-Path $targetRoot '.claude\CLAUDE.md')
Add-GeneratedPathsToGitIgnore
Sync-ClaudeSettings -DestinationFile (Join-Path $targetRoot '.claude\settings.json')
Sync-ClientFile -SourceFile '.codex\config.toml' -DestinationFile (Join-Path $targetRoot '.codex\config.toml')
Sync-ClientFile -SourceFile '.cursor\cli.json' -DestinationFile (Join-Path $targetRoot '.cursor\cli.json')
Sync-ClientFile -SourceFile '.cursor\permissions.json' -DestinationFile (Join-Path $targetRoot '.cursor\permissions.json')
Sync-ClientFile -SourceFile '.vscode\settings.json' -DestinationFile (Join-Path $targetRoot '.vscode\settings.json')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.claude\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.codex\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.cursor\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.github\skills')
Sync-ClaudeRules -DestinationRoot (Join-Path $targetRoot '.claude\rules')
Sync-CursorRules -DestinationRoot (Join-Path $targetRoot '.cursor\rules')
Sync-CopilotRules -DestinationRoot (Join-Path $targetRoot '.github\instructions')
Remove-GeneratedPathsFromGitIndex

Write-Output "Installed shared guidance in '$targetRoot'. Review .gitignore, the .agents submodule pointer, and staged removals of generated files."