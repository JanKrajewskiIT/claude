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

function Add-GeneratedPathsToGitIgnore {
    $gitIgnorePath = Join-Path $targetRoot '.gitignore'
    $existingLines = if (Test-Path $gitIgnorePath) {
        @(Get-Content $gitIgnorePath)
    }
    else {
        @()
    }
    $missingEntries = @(
        '/AGENTS.md'
        '/CLAUDE.md'
        '/.claude/skills/'
        '/.github/skills/'
    ) | Where-Object { $_ -notin $existingLines }

    if ($missingEntries.Count -eq 0) {
        return
    }

    if ($PSCmdlet.ShouldProcess($gitIgnorePath, 'Ignore generated agent skill copies')) {
        $linesToAdd = @()
        if ($existingLines.Count -gt 0 -and $existingLines[-1] -ne '') {
            $linesToAdd += ''
        }

        $linesToAdd += '# Generated agent skill copies'
        $linesToAdd += $missingEntries
        Add-Content -Path $gitIgnorePath -Value $linesToAdd -Encoding UTF8
    }
}

function Remove-GeneratedPathsFromGitIndex {
    if (-not $PSCmdlet.ShouldProcess($targetRoot, 'Stop tracking generated agent files')) {
        return
    }

    & git -C $targetRoot rm -r --cached --ignore-unmatch -f -- AGENTS.md CLAUDE.md .claude/skills .github/skills
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

$agentsFile = Join-Path $targetRoot 'AGENTS.md'
$agentsInstructions = @'
# Agent Instructions

- Read `.agents/AGENTS.md` before modifying this repository.
- Treat `.agents/` as shared guidance and this file as project-specific guidance.
'@

if ($PSCmdlet.ShouldProcess($agentsFile, 'Replace repository agent instructions')) {
    Set-Content -Path $agentsFile -Value $agentsInstructions -Encoding UTF8
}

$claudeFile = Join-Path $targetRoot 'CLAUDE.md'
$claudeInstructions = '@.agents/AGENTS.md'

if ($PSCmdlet.ShouldProcess($claudeFile, 'Replace Claude repository instructions')) {
    Set-Content -Path $claudeFile -Value $claudeInstructions -Encoding UTF8
}

Add-GeneratedPathsToGitIgnore
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.claude\skills')
Sync-Skills -DestinationRoot (Join-Path $targetRoot '.github\skills')
Remove-GeneratedPathsFromGitIndex

Write-Output "Installed shared guidance in '$targetRoot'. Review and commit .gitignore, the .agents submodule pointer, and staged removals of generated files."