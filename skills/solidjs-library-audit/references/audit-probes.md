# Audit Probes

Read-only ripgrep searches. Adjust the `src` path to the library source root.
Copy each command exactly; `|` inside a pattern is regex alternation.

## Declaration Style

Signal: function declarations beside arrow components.

```shell
rg -n "^\s*(export )?(default )?(async )?function " src
```

## Export Style

Signal: mixed default and named component exports.

```shell
rg -c "export default" src
rg -n "^export (const|\{) [A-Z]" src
```

## Type Safety

Signal: casts that a better type removes.

```shell
rg -n " as [A-Z]|as unknown as|as any" src
```

## Prop Forwarding

Signal: forwarded handlers override internal ones. Check each match for spread order against owned handlers.

```shell
rg -n "\{\.\.\.rest\}" src
```

## Conditional JSX

Signal: `&&` instead of `Show`.

```shell
rg -n "\{[a-zA-Z.()]+ && \(" src
```

## Effect Mirrors

Signal: state copied from props by an effect.

```shell
rg -n "defer: true" src
```

## Module State

Signal: global mutable UI state.

```shell
rg -n "^export const \[.*createSignal" src
```

## Cleanup

Signal: more resource registrations than cleanups.

```shell
rg -c "addEventListener|setTimeout|requestAnimationFrame" src
rg -c "onCleanup" src
```

## Error Handling

Signal: ignored failures and exception text shown to users.

```shell
rg -n "catch\(\(\) =>|catch \{\s*\}" src
rg -n "error\.message|err\.message" src
```

## Unsafe HTML

Signal: unsanitized HTML or deprecated editing APIs.

```shell
rg -n "innerHTML|execCommand" src
rg -in "sanitiz" src
```

## Localization

Signal: user-visible literals outside the dictionary.

```shell
rg -n "'(Mo|Tu|Close|Cancel)'" src
```

## Keyboard

Signal: mouse-only table controls. Check matches for a `button` and `aria-sort`.

```shell
rg -n "onClick" src --glob "*Table*"
```

## Forced Colors

Signal: focus ring vanishes in forced-colors mode.

```shell
rg -c "forced-colors" src
rg -c "outline: none" src
```

## CSS Values

Signal: tokens bypassed and inconsistent breakpoints.

```shell
rg -c "[0-9.]+px" src --glob "*.css"
rg -n "!important" src
rg -h "@media" src --glob "*.css"
```

## File Encoding

Signal: byte-order marks. `(?-u)` makes `\x` escapes match raw bytes.

```shell
rg -l "(?-u)^\xEF\xBB\xBF" src
```

## Tooling Drift

Signal: lint selector lists that name absent components. Compare them with:

```shell
git ls-files src
```

## Tests

Signal: no behavioral coverage.

```shell
git ls-files "*.test.*" "*.spec.*"
```

## Large Units

Signal: components above about 250 lines. Count lines per component file with
the shell's line-count facility, such as `wc -l` or `Measure-Object -Line`,
largest first.
