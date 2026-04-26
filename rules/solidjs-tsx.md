---
paths:
  - 'src/**/*.tsx'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# SolidJS TSX

## Language and Reactivity

- Prefer arrow functions for components and local helpers; use `function` only when it clearly improves typing or hoisting
- Never JS-destructure props
- Never React patterns (`useState`, `useEffect`, `className`)
- `splitProps` + `{...rest}` only for real HTML wrapper components with intentional passthrough
- Prefer `createMemo` over `createEffect` for derived state
- Keep multi-step logic out of JSX; define handlers and computed values above `return`

## Props and Exports

- `import type Props from "~/models/Props"` - never deep relative paths
- Inline `Props<T>` in the component signature
- Reuse shared contracts from `~/models/Props.ts` instead of redefining common `aria-*`, `label`, or native props
- Never expose full `JSX.*HTMLAttributes` on public component APIs; use narrow shared subsets plus explicit semantic props
- Keep `name` local to form-like controls only
- Prefer `export default` for public components unless named export is materially clearer
- Public components must be exported from `src/index.ts`

## Imports and Shared Utilities

- Always use `~/` path aliases for hooks, utils, and models
- Use `classNames()` for conditional classes
- Merge ARIA ids with `joinAriaIds()` and derive validation ARIA with `resolveAriaInvalid()` / `resolveAriaErrorMessage()` when applicable

## Primitive Hierarchy

- Use VelvetUi primitives instead of raw HTML equivalents wherever possible:
  - `Heading` for headings
  - `Text` for body copy
  - `Button` / `IconButton` / `ButtonBase` for actions and triggers
  - `Input` / `TextArea` / `InputBase` for text fields
- Label-driven APIs should prefer semantic props like `label`, `message`, `description`
- Prefer `label` over `title` for component-level labels; reserve `title` for real domain data
- Use `LabelText` for label/description rendering instead of duplicating inline text stacks

## Style Prop

- Always use object syntax: `style={{ key: value }}`
- Inline style is reserved for truly runtime-driven values; for everything else see `rules/css-modules`

## Accessibility

- Every interactive control must be keyboard reachable and operable with a visible focus state using shared focus tokens
- Component semantics must expose correct role and accessible name by default; preserve semantic labeling when labels are visually hidden or composed
- ARIA wiring for field-shaped components: see `rules/aria-wiring`
- Overlay focus and dismissal contracts: see `skills/overlay-patterns`
