---
name: accessible-composite-widgets
description: Design, implement, or review accessible menus, listboxes, comboboxes, selects, autocompletes, command palettes, and related composite widgets. Use when the primary challenge is widget semantics and item interaction, including ARIA roles, active-item focus, keyboard navigation, selection, filtering, disabled items, or typeahead behavior.
---

# Accessible Composite Widgets

## Goal

- Select the correct accessibility pattern before implementing shared keyboard behavior.
- Keep focus, active item, selection, value, and popup state distinct.

## Do Not Use

- Use `accessible-overlays` for dialog, drawer, and popover lifecycle, modality, dismissal, and return focus.

## Workflow

1. Identify the user task.
   - Use a menu for actions or commands.
   - Use a listbox or select for choosing option values.
   - Use a combobox when an input controls or filters a popup.
   - Use native controls when customization does not justify replacing them.
2. Verify the current pattern.
   - Consult the current WAI-ARIA Authoring Practices for the chosen widget.
   - Do not combine roles or keyboard contracts from different patterns casually.
3. Define the state model.
   - Separate open state, focus owner, active item, selected items, committed value, filter text, and highlighted match.
   - Assign stable identifiers to items used by active-descendant relationships.
4. Choose the focus model.
   - Use roving focus when DOM focus moves among items.
   - Use `aria-activedescendant` when focus stays on a controlling input or container.
   - Keep the visual active state synchronized with the chosen focus model.
   - Use [`references/examples.md`](references/examples.md) to compare pattern-specific state and keyboard behavior.
5. Implement navigation.
   - Define Arrow, Home, End, Enter, Space, Escape, and Tab behavior for the selected pattern.
   - Add typeahead only when appropriate to the role and content.
   - Skip unavailable items during navigation while preserving their discoverability semantics.
6. Implement selection and activation.
   - Route pointer and keyboard activation through the same state transition.
   - Distinguish moving the active item from committing a value or invoking an action.
   - Define whether selection closes the popup.
7. Handle dynamic content.
   - Preserve a valid active item when filtering, loading, disabling, or removing options.
   - Announce loading, empty, error, or result-count changes when users need them.
8. Integrate the popup.
   - Connect controller and popup relationships with the attributes required by the selected pattern.
   - Coordinate outside dismissal and return focus without overriding natural Tab navigation.
9. Propose validation.
   - Test the complete keyboard contract, disabled items, filtering, selection, focus visibility, zoom, and assistive-technology output.
   - List exact commands and ask before running them unless already approved.

## Pattern Boundaries

| Pattern | Primary purpose | Typical focus owner |
|---|---|---|
| Menu | Invoke an action | Menu item or menu container |
| Listbox | Select one or more values | Option or listbox container |
| Combobox | Edit or choose through an input | Input with controlled popup |
| Native select | Choose a value with platform behavior | Native control |

## Constraints

- Do not create one universal keyboard handler for menus, listboxes, and comboboxes.
- Do not equate active item with selected value.
- Do not make Tab cycle inside a non-modal popup.
- Do not expose disabled items as actionable.
- Do not use ARIA to replace working native semantics without a clear need.

## Completion Criteria

- The role and keyboard contract match the user task.
- Focus, active state, selection, and committed value remain consistent.
- Pointer and keyboard interaction produce equivalent outcomes.
- Dynamic content never leaves an invalid active reference.
- Proposed checks cover the chosen pattern rather than a generic dropdown model.
