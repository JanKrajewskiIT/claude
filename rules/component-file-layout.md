---
paths:
  - 'src/components/**/*.tsx'
  - 'src/components/**/*.module.css'
  - 'src/index.ts'
---

# Component File Layout & Barrel Exports

## Folder layout

- One folder per component: `src/components/<category>/<Name>/<Name>.tsx` + `<Name>.module.css`
- File name MUST match folder name
- Compound parts live in sibling folders under the same parent (`Dialog/`, `DialogTitle/`, `DialogBody/`)
- Compound Context lives in `<Name>Context.ts` next to the parent
- No `index.ts` re-exports inside component folders

## Default vs named exports

- Components: `export default`
- Hooks: `export default`
- Factories, providers, primitive utilities (`createAppQuery`, `AuthProvider`, `configureVelvet`, `useAuth`): named
- Variant unions, `*Props`, `*OwnProps`, `*Messages`: named, from the same file as the component

## Props naming

- `<Name>Props` — full props
- `<Name>OwnProps` — additions over a native element when polymorphic/extending a primitive
- Always export `<Name>Props` for non-trivial components
- Export `<Name>OwnProps` only when the component extends/forwards a base set

## Variants & lookups

- Size/variant maps live in `shared/<name>Variants.ts` next to the family, or in `~/utils/`
- Never inline string-template class lookups in components
- Reuse `getInputSizeClass()` and similar shared helpers

## Barrel: `src/index.ts`

- Strictly alphabetized export blocks
- Group `export { default as X }` and `export type { XProps, XVariant }` from the same file as adjacent statements
- No dot-notation compound APIs (no `Dialog.Title`); each compound part is a flat export
- Public hooks re-exported from `src/index.ts`; internal hooks stay unexported

## CSS module pairing

- `ComponentName.tsx` MUST pair with `ComponentName.module.css` when it owns styles
- Drop the `.module.css` when no styles remain; never leave orphans
