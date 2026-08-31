# Composite Widget Examples

Verify exact keyboard behavior against the current WAI-ARIA Authoring Practices.

## Combobox State

```ts
type ComboboxState = {
  inputValue: string;
  selectedValue: string | null;
  activeOptionId: string | null;
  expanded: boolean;
};
```

Input text, active option, and committed selection are separate values. DOM focus
typically remains on the input while `aria-activedescendant` identifies the option.

## Menu Activation

```text
Arrow keys -> move focus among menu items
Enter/Space -> invoke the focused action
Escape -> close and return focus to the trigger
Tab -> leave the menu; do not cycle inside it
```

A menu invokes commands. Do not reuse its activation model for a listbox that
selects values.

## Disabled Item

```text
visible and semantically disabled
not selectable or invokable
navigation behavior follows the chosen APG pattern
```
