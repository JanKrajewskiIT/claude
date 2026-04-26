---
paths:
  - 'src/components/**/*.tsx'
  - 'src/components/**/*.module.css'
  - 'src/index.ts'
---

> Type: Rule (normative constraints)

# Component File Layout and Barrel Exports

## Folder Layout

- One folder per component: `src/components/<category>/<Name>/<Name>.tsx` + `<Name>.module.css`
- File name MUST match folder name exactly
- Sub-parts of a compound component live in sibling folders under the same parent (e.g. `Dialog/`, `DialogTitle/`, `DialogBody/`, `DialogActions/`)
- Local Context for a compound component lives in `<Name>Context.ts` next to the parent
- No `index.ts` re-exports inside component folders

## Default vs Named Exports

- Components: `export default` the component
- Hooks: `export default` the hook
- Factories, providers, and primitive utilities (e.g. `createAppQuery`, `AuthProvider`, `configureVelvet`, `useAuth`): named exports
- Variant unions, `*Props`, `*OwnProps`, `*Messages`: named exports from the same file as the component

## Props Type Naming

- `<Name>Props` is the full props type the component accepts
- `<Name>OwnProps` is the additions over a native element when the component is polymorphic or extends a primitive
- Always export `<Name>Props` for components that take any non-trivial props
- Export `<Name>OwnProps` only when the component extends/forwards a base set

## Variant and Lookup Tables

- Size and variant maps live in `shared/<name>Variants.ts` next to the family, or in `~/utils/`
- Never inline string-template class lookups inside the component
- Reuse `getInputSizeClass()` and similar shared helpers instead of redefining size maps per component

## Barrel: `src/index.ts`

- Strictly alphabetized export blocks
- Group `export { default as X }` and `export type { XProps, XVariant }` from the same file as adjacent statements
- Do NOT use dot-notation compound APIs (no `Dialog.Title`); each compound part is a separate flat export
- Hooks intended as public API are re-exported from `src/index.ts`; internal hooks stay unexported

## CSS Module Pairing

- `ComponentName.tsx` MUST pair with `ComponentName.module.css` when the component owns any styles
- Drop the `.module.css` file when no styles remain; never leave orphaned modules
