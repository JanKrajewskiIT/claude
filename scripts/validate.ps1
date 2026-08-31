[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path $PSScriptRoot -Parent
$skillsRoot = Join-Path $repositoryRoot 'skills'
$rulesRoot = Join-Path $repositoryRoot 'rules'
$repositoryReadme = Join-Path $repositoryRoot 'README.md'
$claudeSettings = Join-Path $repositoryRoot '.claude\settings.json'
$jsonClientSettings = @(
    (Join-Path $repositoryRoot '.cursor\cli.json')
    (Join-Path $repositoryRoot '.cursor\permissions.json')
    (Join-Path $repositoryRoot '.vscode\settings.json')
)
$codexSettings = Join-Path $repositoryRoot '.codex\config.toml'
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([string]$Message)

    $failures.Add($Message)
}

function Get-LocalLinkTargets {
    param(
        [string]$File,
        [string]$BaseDirectory
    )

    $content = Get-Content $File -Raw
    $matches = [regex]::Matches($content, '\[[^\]]+\]\((?![a-z][a-z0-9+.-]*:|#)([^)#]+)(?:#[^)]+)?\)', 'IgnoreCase')

    foreach ($match in $matches) {
        $relativePath = [Uri]::UnescapeDataString($match.Groups[1].Value)
        [PSCustomObject]@{
            RelativePath = $relativePath
            FullPath = [IO.Path]::GetFullPath((Join-Path $BaseDirectory $relativePath))
        }
    }
}

function Test-LocalLinks {
    param(
        [string]$File,
        [string]$BaseDirectory
    )

    foreach ($target in @(Get-LocalLinkTargets -File $File -BaseDirectory $BaseDirectory)) {
        if (-not (Test-Path $target.FullPath)) {
            Add-Failure "${File}: broken local link '$($target.RelativePath)'"
        }
    }
}

function Test-SkillResources {
    param(
        [System.IO.DirectoryInfo]$SkillDirectory,
        [string]$SkillFile
    )

    $markdownFiles = @(Get-ChildItem $SkillDirectory.FullName -Filter '*.md' -File -Recurse)
    foreach ($markdownFile in $markdownFiles) {
        Test-LocalLinks -File $markdownFile.FullName -BaseDirectory $markdownFile.DirectoryName
    }

    $reachable = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $pendingMarkdown = [System.Collections.Generic.Queue[string]]::new()
    $pendingMarkdown.Enqueue([IO.Path]::GetFullPath($SkillFile))

    while ($pendingMarkdown.Count -gt 0) {
        $markdownFile = $pendingMarkdown.Dequeue()
        if (-not $reachable.Add($markdownFile)) {
            continue
        }

        foreach ($target in @(Get-LocalLinkTargets -File $markdownFile -BaseDirectory (Split-Path $markdownFile -Parent))) {
            if (-not (Test-Path $target.FullPath -PathType Leaf)) {
                continue
            }

            $reachable.Add($target.FullPath) | Out-Null
            if ([IO.Path]::GetExtension($target.FullPath) -eq '.md') {
                $pendingMarkdown.Enqueue($target.FullPath)
            }
        }
    }

    foreach ($resourceDirectoryName in @('references', 'assets')) {
        $resourceDirectory = Join-Path $SkillDirectory.FullName $resourceDirectoryName
        if (-not (Test-Path $resourceDirectory -PathType Container)) {
            continue
        }

        foreach ($resourceFile in @(Get-ChildItem $resourceDirectory -File -Recurse)) {
            if (-not $reachable.Contains($resourceFile.FullName)) {
                Add-Failure "$($SkillDirectory.Name): unreachable resource '$($resourceFile.FullName.Substring($SkillDirectory.FullName.Length + 1))'"
            }
        }
    }
}

if (-not (Test-Path $skillsRoot -PathType Container)) {
    Add-Failure "Missing skills directory: $skillsRoot"
}

if (-not (Test-Path $repositoryReadme -PathType Leaf)) {
    Add-Failure "Missing repository README: $repositoryReadme"
}

if (Test-Path (Join-Path $repositoryRoot 'settings.json') -PathType Leaf) {
    Add-Failure 'Claude settings must be stored at .claude/settings.json, not repository-root settings.json'
}

if (-not (Test-Path $claudeSettings -PathType Leaf)) {
    Add-Failure "Missing Claude project settings: $claudeSettings"
}
else {
    try {
        $settings = Get-Content $claudeSettings -Raw | ConvertFrom-Json
        if (@($settings.permissions.allow) -contains 'Bash(*)') {
            Add-Failure '.claude/settings.json must not grant unrestricted Bash(*) permission'
        }
    }
    catch {
        Add-Failure ".claude/settings.json is not valid JSON: $($_.Exception.Message)"
    }
}

foreach ($settingsFile in $jsonClientSettings) {
    if (-not (Test-Path $settingsFile -PathType Leaf)) {
        Add-Failure "Missing client settings: $settingsFile"
        continue
    }

    try {
        Get-Content $settingsFile -Raw | ConvertFrom-Json | Out-Null
    }
    catch {
        Add-Failure "$settingsFile is not valid JSON: $($_.Exception.Message)"
    }
}

if (-not (Test-Path $codexSettings -PathType Leaf)) {
    Add-Failure "Missing Codex project settings: $codexSettings"
}
elseif ((Get-Content $codexSettings -Raw) -match '(?m)^\s*(approval_policy\s*=\s*"never"|sandbox_mode\s*=\s*"danger-full-access")') {
    Add-Failure '.codex/config.toml must not disable approvals or use danger-full-access'
}

$skillDirectories = if (Test-Path $skillsRoot -PathType Container) {
    @(Get-ChildItem $skillsRoot -Directory | Sort-Object Name)
}
else {
    @()
}
$seenNames = @{}

foreach ($skillDirectory in $skillDirectories) {
    $skillFile = Join-Path $skillDirectory.FullName 'SKILL.md'

    if (-not (Test-Path $skillFile -PathType Leaf)) {
        Add-Failure "$($skillDirectory.Name): missing SKILL.md"
        continue
    }

    $content = Get-Content $skillFile -Raw
    $frontmatter = [regex]::Match($content, '\A---\r?\n(?<yaml>.*?)\r?\n---(?:\r?\n|\z)', 'Singleline')

    if (-not $frontmatter.Success) {
        Add-Failure "$($skillDirectory.Name): missing or malformed YAML frontmatter"
        continue
    }

    $yaml = $frontmatter.Groups['yaml'].Value
    $nameMatch = [regex]::Match($yaml, '(?m)^name:\s*["'']?(?<value>[^\r\n"'']+)["'']?\s*$')
    $descriptionMatch = [regex]::Match($yaml, '(?m)^description:\s*["'']?(?<value>[^\r\n]+?)["'']?\s*$')

    if (-not $nameMatch.Success) {
        Add-Failure "$($skillDirectory.Name): missing name"
    }
    else {
        $name = $nameMatch.Groups['value'].Value.Trim()

        if ($name -ne $skillDirectory.Name) {
            Add-Failure "$($skillDirectory.Name): name '$name' does not match its directory"
        }

        if ($name.Length -gt 64 -or $name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
            Add-Failure "$($skillDirectory.Name): invalid name '$name'"
        }

        if ($seenNames.ContainsKey($name)) {
            Add-Failure "$($skillDirectory.Name): duplicate name '$name'"
        }
        else {
            $seenNames[$name] = $true
        }
    }

    if (-not $descriptionMatch.Success) {
        Add-Failure "$($skillDirectory.Name): missing description"
    }
    else {
        $description = $descriptionMatch.Groups['value'].Value.Trim()

        if ($description.Length -lt 1 -or $description.Length -gt 1024) {
            Add-Failure "$($skillDirectory.Name): description must contain 1-1024 characters"
        }

        if ($description -notmatch '(?i)\buse when\b') {
            Add-Failure "$($skillDirectory.Name): description must state when to use the skill"
        }
    }

    if (@(Get-Content $skillFile).Count -gt 500) {
        Add-Failure "$($skillDirectory.Name): SKILL.md exceeds 500 lines"
    }

    Test-SkillResources -SkillDirectory $skillDirectory -SkillFile $skillFile

    if (Test-Path $repositoryReadme) {
        $catalogPath = "skills/$($skillDirectory.Name)/"
        $readmeContent = Get-Content $repositoryReadme -Raw

        if ($readmeContent -notmatch [regex]::Escape($catalogPath)) {
            Add-Failure "$($skillDirectory.Name): missing from README catalog"
        }
    }
}

if (Test-Path $repositoryReadme) {
    Test-LocalLinks -File $repositoryReadme -BaseDirectory $repositoryRoot
}

$rulesReadme = Join-Path $repositoryRoot 'rules\README.md'
if (Test-Path $rulesReadme) {
    Test-LocalLinks -File $rulesReadme -BaseDirectory (Split-Path $rulesReadme -Parent)

    $rulesReadmeContent = Get-Content $rulesReadme -Raw
    foreach ($ruleFile in @(Get-ChildItem $rulesRoot -Filter '*.md' -File | Where-Object { $_.Name -ne 'README.md' })) {
        if ($rulesReadmeContent -notmatch [regex]::Escape("$($ruleFile.BaseName).md")) {
            Add-Failure "$($ruleFile.Name): missing from rules/README.md catalog"
        }

        if ((Get-Content $ruleFile.FullName -Raw) -notmatch '(?m)^#\s+\S') {
            Add-Failure "$($ruleFile.Name): missing top-level heading"
        }
    }
}
else {
    Add-Failure "Missing rules README: $rulesReadme"
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure
    }

    exit 1
}

Write-Output "PASS: validated $($skillDirectories.Count) skill packages and repository links."
