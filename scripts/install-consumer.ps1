[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$TargetRepository
)

$ErrorActionPreference = 'Stop'
$guidanceRoot = Split-Path $PSScriptRoot -Parent
$defaultTargetRoot = Split-Path $guidanceRoot -Parent
$targetRoot = if ($TargetRepository) {
    [IO.Path]::GetFullPath($TargetRepository)
}
else {
    $defaultTargetRoot
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

function Get-RuleApplyTo {
    param([string]$RuleName)

    switch ($RuleName) {
        'css-modules-conventions' { '**/*.module.css,**/*.module.scss,**/*.module.sass,**/*.module.less' }
        'dotnet-conventions' { '**/*.cs,**/*.csproj,**/*.fs,**/*.fsproj,**/*.sln,**/*.slnx' }
        'dotnet-error-handling' { '**/*.cs,**/*.csproj,**/*.fs,**/*.fsproj' }
        'frontend-accessibility' { '**/*.html,**/*.htm,**/*.tsx,**/*.jsx,**/*.vue,**/*.svelte,**/*.razor' }
        'solidjs-conventions' { '**/*.tsx,**/*.jsx' }
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
        $paths = @((Get-RuleApplyTo -RuleName $name) -split ',' | ForEach-Object { "  - `"$($_)`"" }) -join "`r`n"
        $content = Get-Content $rule.FullName -Raw
        $adapter = "---`r`npaths:`r`n$paths`r`n---`r`n`r`n$content"
        Set-Content -Path (Join-Path $DestinationRoot $rule.Name) -Value $adapter -Encoding UTF8
    }
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
        $applyTo = Get-RuleApplyTo -RuleName $name
        $content = Get-Content $rule.FullName -Raw
        $adapter = "---`r`nname: $name`r`ndescription: Shared $name guidance`r`napplyTo: `"$applyTo`"`r`n---`r`n`r`n$content"
        Set-Content -Path (Join-Path $DestinationRoot "$name.instructions.md") -Value $adapter -Encoding UTF8
    }
}

function Update-AgentInstructions {
    param([string]$File)

    $beginMarker = '<!-- BEGIN SHARED AGENT GUIDANCE -->'
    $endMarker = '<!-- END SHARED AGENT GUIDANCE -->'
    $managedBlock = @"
$beginMarker
## Shared Agent Guidance

- Treat `.agents/` as the canonical source of shared guidance.
- Resolve shared paths below from `.agents/`.
- Discover task-specific workflows in `.agents/skills/` and load a skill when its description matches the requested outcome.
- Read `.agents/rules/agent-execution.md` and `.agents/rules/git-and-change-safety.md` before modifying the repository.
- Read `.agents/rules/security-boundaries.md` when work crosses trust, secret, data, or integration boundaries.
- Read matching stack rules before changing .NET, SolidJS, CSS Modules, or user-interface files.
- Treat loaded rules as higher priority than task-specific skill advice.
- Follow project instructions outside this managed block; the more specific instruction wins on conflict.
$endMarker
"@
    $legacyContent = @'
# Agent Instructions

- Read `.agents/AGENTS.md` before modifying this repository.
- Treat `.agents/` as shared guidance and this file as project-specific guidance.
'@
    $existingContent = if (Test-Path $File) { Get-Content $File -Raw } else { '' }
    $managedPattern = "(?s)$([regex]::Escape($beginMarker)).*?$([regex]::Escape($endMarker))"

    if ($existingContent -match $managedPattern) {
        $updatedContent = [regex]::Replace($existingContent, $managedPattern, $managedBlock)
    }
    elseif ($existingContent.Trim() -eq $legacyContent.Trim()) {
        $updatedContent = $managedBlock
    }
    elseif ($existingContent.Trim().Length -gt 0) {
        $updatedContent = "$managedBlock`r`n`r`n$($existingContent.TrimStart())"
    }
    else {
        $updatedContent = $managedBlock
    }

    if ($PSCmdlet.ShouldProcess($File, 'Update managed shared guidance block')) {
        Set-Content -Path $File -Value $updatedContent -Encoding UTF8
    }
}

function Update-ClaudeInstructions {
    param([string]$File)

    $legacyContent = '@.agents/AGENTS.md'
    if (Test-Path $File) {
        $existingContent = Get-Content $File -Raw
        if ($existingContent.Trim() -ne $legacyContent) {
            return
        }
    }

    if ($PSCmdlet.ShouldProcess($File, 'Point Claude at repository AGENTS.md')) {
        Set-Content -Path $File -Value '@AGENTS.md' -Encoding UTF8
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
    $obsoleteEntries = @('/AGENTS.md', '/CLAUDE.md')
    $retainedLines = @($existingLines | Where-Object { $_ -notin $obsoleteEntries })
    $generatedEntries = @(
        '/.claude/skills/'
        '/.claude/rules/shared-agents/'
        '/.github/skills/'
        '/.github/instructions/shared-agents/'
    )
    $missingEntries = @($generatedEntries | Where-Object { $_ -notin $retainedLines })

    if ($missingEntries.Count -eq 0 -and $retainedLines.Count -eq $existingLines.Count) {
        return
    }

    if ($PSCmdlet.ShouldProcess($gitIgnorePath, 'Ignore generated agent skill copies')) {
        $linesToAdd = @($retainedLines)
        if ($linesToAdd.Count -gt 0 -and $linesToAdd[-1] -ne '') {
            $linesToAdd += ''
        }

        if ('# Generated agent skill copies' -notin $linesToAdd) {
            $linesToAdd += '# Generated agent skill copies'
        }
        $linesToAdd += $missingEntries
        Set-Content -Path $gitIgnorePath -Value $linesToAdd -Encoding UTF8
    }
}

function Remove-GeneratedPathsFromGitIndex {
    if (-not $PSCmdlet.ShouldProcess($targetRoot, 'Stop tracking generated agent files')) {
        return
    }

    & git -C $targetRoot rm -r --cached --ignore-unmatch -f -- .claude/skills .claude/rules/shared-agents .github/skills .github/instructions/shared-agents
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
Update-ClaudeInstructions -File (Join-Path $targetRoot 'CLAUDE.md')
Add-GeneratedPathsToGitIgnore
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.claude\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.github\skills')
Sync-ClaudeRules -DestinationRoot (Join-Path $targetRoot '.claude\rules\shared-agents')
Sync-CopilotRules -DestinationRoot (Join-Path $targetRoot '.github\instructions\shared-agents')
Remove-GeneratedPathsFromGitIndex

Write-Output "Installed shared guidance in '$targetRoot'. Review AGENTS.md, CLAUDE.md, .gitignore, the .agents submodule pointer, and staged removals of generated files."