---
paths:
  - 'src/components/**/*.tsx'
---

> Type: Rule (normative constraints)

# ARIA Wiring

Form-shaped and field-shaped components MUST wire ARIA through the shared helpers in `~/utils/aria.ts`.

## Required Helpers

- `joinAriaIds(...)` for any `aria-labelledby` / `aria-describedby` / `aria-errormessage` composition
- `resolveAriaInvalid(props)` for `aria-invalid`
- `resolveAriaErrorMessage(props)` for `aria-errormessage`

## Required for Field-Shaped Components

`Input`, `TextArea`, `Select`, `MultiSelect`, `Autocomplete`, `DatePicker`, `TimePicker`, `Slider`, custom controls, and any other component built on `FieldBase` MUST:

- Accept `label`, `description`, and `error`/`message`-style props
- Generate stable internal ids and join them with `joinAriaIds`
- Wire `aria-invalid` and `aria-errormessage` via the shared helpers — never inline boolean coercion
- Connect via `FormField` when the component is rendered inside one

## Forbidden

- Hand-written `aria-describedby` string concatenation
- Conditional `aria-invalid={isInvalid ? 'true' : undefined}` written inline instead of through `resolveAriaInvalid`
- Skipping ARIA wiring because the component "is usually inside a label"
