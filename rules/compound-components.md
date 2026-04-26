---
paths:
  - 'src/components/**/*.tsx'
  - 'src/index.ts'
---

> Type: Rule (normative constraints)

# Compound Component APIs

VelvetUi compound components use **flat exports + Context**, never dot-notation.

## Required Pattern

- Each compound part is a separately-imported default export: `Dialog`, `DialogTitle`, `DialogBody`, `DialogActions`
- The parent owns a `<Name>Context.ts` with `createContext<...>()` + a guarded `use<Name>Context()` hook that throws when used outside the provider
- Children read shared state through the context, not through props drilling
- Examples in tree: `Dialog`, `Accordion` (`Accordion`/`AccordionItem`/`AccordionIcon`), `Table` (`Table`/`TableBody`/`TableCell`/`TableHead`/`TableHeader`/`TableRow`)

## Forbidden

- `Dialog.Title = DialogTitle` style attachments
- Re-exporting parts as nested namespaces from the barrel
- Children that read parent state through props passed manually by every consumer

## Context Hook Discipline

- The context hook MUST throw a clear error when its provider is missing
- Keep the context value minimal and stable; do not stuff every primitive's state into one context
