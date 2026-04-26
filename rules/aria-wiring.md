---
paths:
  - 'src/components/**/*.tsx'
---

# ARIA Wiring

Form-shaped and field-shaped components MUST wire ARIA through `~/utils/aria.ts`.

## Required helpers

- `joinAriaIds(...)` for `aria-labelledby` / `aria-describedby` / `aria-errormessage`
- `resolveAriaInvalid(props)` for `aria-invalid`
- `resolveAriaErrorMessage(props)` for `aria-errormessage`

## Required for field-shaped components

`Input`, `TextArea`, `Select`, `MultiSelect`, `Autocomplete`, `DatePicker`, `TimePicker`, `Slider`, and anything built on `FieldBase` MUST:

- Accept `label`, `description`, `error`/`message` props
- Generate stable internal ids and join them with `joinAriaIds`
- Wire `aria-invalid` / `aria-errormessage` via the helpers — never inline
- Connect via `FormField` when rendered inside one

## Forbidden

- Hand-written `aria-describedby` string concatenation
- Inline `aria-invalid={isInvalid ? 'true' : undefined}` instead of `resolveAriaInvalid`
- Skipping ARIA wiring because the component "is usually inside a label"
