---
paths:
  - 'src/components/**/*.tsx'
  - 'src/index.ts'
---

# Compound Component APIs

VelvetUi compound components use **flat exports + Context**, never dot-notation.

## Required pattern

- Each part is a separate default export: `Dialog`, `DialogTitle`, `DialogBody`, `DialogActions`
- Parent owns `<Name>Context.ts` with `createContext<...>()` + a guarded `use<Name>Context()` hook that throws when used outside the provider
- Children read shared state through context, not via prop drilling
- Examples: `Dialog`, `Accordion` (`Accordion`/`AccordionItem`/`AccordionIcon`), `Table` (`Table`/`TableBody`/`TableCell`/`TableHead`/`TableHeader`/`TableRow`)

## Forbidden

- `Dialog.Title = DialogTitle` style attachments
- Re-exporting parts as nested namespaces from the barrel
- Children that read parent state through manually-passed props

## Context discipline

- The context hook MUST throw a clear error when its provider is missing
- Keep context value minimal and stable; do not stuff every primitive's state into one context
