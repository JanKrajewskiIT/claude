# Audit Probes

Read-only searches. Adjust the `src` path to the library source root.

| Dimension | Probe | Signal |
|---|---|---|
| Declaration style | `rg -n "^\s*(export )?(default )?(async )?function " src` | Function declarations beside arrow components |
| Export style | `rg -c "export default" src` and `rg "^export (const\|\{) [A-Z]" src` | Mixed default and named component exports |
| Type safety | `rg -n " as [A-Z]\|as unknown as\|as any" src` | Casts that a better type removes |
| Prop forwarding | `rg -n "\{\.\.\.rest\}" src` then check order against owned handlers | Forwarded handlers override internal ones |
| Conditional JSX | `rg -n "\{[a-zA-Z.()]+ && \(" src` | `&&` instead of `Show` |
| Effect mirrors | `rg -n "defer: true" src` | State copied from props by effect |
| Module state | `rg -n "^export const \[.*createSignal" src` | Global mutable UI state |
| Cleanup | `rg -c "addEventListener\|setTimeout\|requestAnimationFrame" src` vs `rg -c "onCleanup" src` | Unreleased resources |
| Error swallowing | `rg -n "catch\(\(\) =>\|catch \{\s*\}" src` | Ignored failures |
| Raw errors | `rg -n "error\.message\|err\.message" src` | Exception text shown to users |
| Unsafe HTML | `rg -n "innerHTML\|execCommand" src` and `rg -in "sanitiz" src` | Unsanitized HTML |
| Localization | `rg -n "'(Mo\|Tu\|Close\|Cancel)'" src` | Literals outside the dictionary |
| Keyboard | `rg -n "onClick" src --glob "*Table*"` and check for `button` and `aria-sort` | Mouse-only controls |
| Forced colors | `rg -c "forced-colors" src` against `rg -c "outline: none" src` | Focus ring vanishes |
| CSS values | `rg -c "[0-9.]+px" src --glob "*.css"` and `rg -n "!important" src` | Tokens bypassed |
| Breakpoints | `rg -h "@media" src --glob "*.css"` | Inconsistent breakpoint values |
| File encoding | `rg -l "^\xEF\xBB\xBF" src` | Byte-order marks |
| Tooling drift | Compare lint selector lists with `git ls-files` component names | Entries for absent components |
| Tests | `git ls-files` filtered for test and spec files | No behavioral coverage |
| Large units | `wc -l` on component files, largest first | Components above about 250 lines |
