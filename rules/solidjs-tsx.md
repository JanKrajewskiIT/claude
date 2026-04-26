---
paths:
  - 'src/**/*.tsx'
---

# SolidJS TSX

## Language & reactivity

- Arrow functions for components and local helpers; `function` only when it improves typing/hoisting
- NEVER JS-destructure props
- NEVER React patterns (`useState`, `useEffect`, `className`)
- `splitProps` + `{...rest}` only for real HTML wrapper components with intentional passthrough
- Prefer `createMemo` over `createEffect` for derived state
- Keep multi-step logic out of JSX; define handlers and computed values above `return`

## Props & exports

- `import type Props from "~/models/Props"` — never deep relative paths
- Inline `Props<T>` in the component signature
- Reuse shared contracts from `~/models/Props.ts` instead of redefining common `aria-*`, `label`, native props
- Never expose full `JSX.*HTMLAttributes` on public component APIs; use narrow shared subsets + explicit semantic props
- `name` is local to form-like controls only
- Prefer `export default` for public components unless named is materially clearer
- Public components must be exported from `src/index.ts`

## Imports & shared utilities

- Always use `~/` path aliases for hooks, utils, models
- `classNames()` for conditional classes
- Merge ARIA ids with `joinAriaIds()`; derive validation ARIA with `resolveAriaInvalid()`/`resolveAriaErrorMessage()`

## Primitive hierarchy

Use VelvetUi primitives over raw HTML:

- `Heading` for headings
- `Text` for body copy
- `Button` / `IconButton` / `ButtonBase` for actions and triggers
- `Input` / `TextArea` / `InputBase` for text fields

Label-driven APIs prefer semantic props: `label`, `message`, `description`. Prefer `label` over `title` for component labels; reserve `title` for real domain data. Use `LabelText` for label/description rendering instead of duplicating inline text stacks.

## Style prop

- Always object syntax: `style={{ key: value }}`
- Inline style is reserved for runtime-driven values; for everything else see `rules/css-modules`

## Accessibility

- Every interactive control MUST be keyboard reachable with a visible focus state using shared focus tokens
- Component semantics MUST expose correct role and accessible name by default
- ARIA wiring for field-shaped components: see `rules/aria-wiring`
- Overlay focus and dismissal: see `skills/overlay-patterns`
