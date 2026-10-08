# Audit Commands

Adapt paths. All commands are read-only. PowerShell shown; use equivalents elsewhere.

## Hash comparison of CSS

```powershell
$ref = 'reference\components'; $port = 'src\styles\components'
Get-ChildItem $ref -Recurse -Filter *.css | ForEach-Object {
  $rel = $_.FullName.Substring((Resolve-Path $ref).Path.Length)
  $other = Join-Path $port $rel
  [pscustomobject]@{ File = $rel; Same = (Test-Path $other) -and ((Get-FileHash $_.FullName).Hash -eq (Get-FileHash $other).Hash) }
} | Where-Object { -not $_.Same }
```

Repeat for tokens, fonts and the entry stylesheet. An empty result means identical.

## Entry stylesheet imports versus files

List `@import` targets of the entry stylesheet and test that each exists in the reference. Missing targets mean a partial reference.

## Export inventory

- Reference: search component sources for `export` declarations and for `window.` registrations if the reference registers globally.
- Port: search `export (default )?(function|const|class) Name` and index re-exports.
- Compare name sets. Resolve differences through a hand-written mapping table (rename, merge, split) rather than fuzzy matching.

## Export coverage by name

Collect exported names from every reference type declaration and check that each appears in the port, either as a declaration or inside an `export { ... }` list.

```powershell
$ref = @{}
Get-ChildItem reference\components -Recurse -Filter *.d.ts | ForEach-Object {
  Select-String -Path $_.FullName -Pattern '^\s*export\s+(?:declare\s+)?(?:default\s+)?(?:function|const|interface|type|class|enum)\s+(\w+)' |
    ForEach-Object { $ref[$_.Matches[0].Groups[1].Value] = $_.Path }
}
$text = (Get-ChildItem src -Recurse -Include *.ts,*.tsx | ForEach-Object { Get-Content $_.FullName -Raw }) -join "`n"
$found = @{}
[regex]::Matches($text, '(?m)^\s*export\s+(?:default\s+)?(?:declare\s+)?(?:function|const|interface|type|class|enum)\s+(\w+)') | ForEach-Object { $found[$_.Groups[1].Value] = 1 }
[regex]::Matches($text, 'export\s*(?:type\s*)?\{([^}]*)\}') | ForEach-Object {
  $_.Groups[1].Value -split ',' | ForEach-Object { $n = ($_ -split '\s+as\s+' | Select-Object -Last 1) -replace '^\s*type\s+', ''; if ($n.Trim()) { $found[$n.Trim()] = 1 } }
}
$missing = $ref.Keys | Where-Object { -not $found.ContainsKey($_) }
"reference names: $($ref.Keys.Count); missing in port: $(@($missing).Count)"
```

Use `$ref.Keys.Count`: a component named `Count` shadows `$ref.Count`.

## Per-component checks

- Props: compare the type declaration with the Props interface.
- Classes: extract string literals that start with the design-system class prefix from both files and diff the sets.
- Accessibility: search both files for `aria-`, `role=`, `tabIndex`, `onKeyDown`, `focus(`.
- Lifecycle: search for `setTimeout`, `requestAnimationFrame`, `addEventListener`, `ResizeObserver` and confirm a matching cleanup.

## Pitfalls

- Shell output may mangle non-ASCII text; read such files with a file reader.
- Split components share a reference file: compare the union of the split files.
- Names that match in a name-only comparison may still differ in props; run the per-component checks for each.
- Parallel agents audit one group each; recheck their claims with one of the searches above.
