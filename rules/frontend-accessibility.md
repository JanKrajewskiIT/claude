# Frontend Accessibility

## Scope

- Apply this rule when creating, changing, or reviewing user interfaces.
- Treat WCAG 2.2 level AA as the baseline unless the project defines a stricter target.

## Semantics

- Use native elements and behavior before custom roles.
- Give controls programmatic names and expose relationships to instructions and errors.
- Keep heading, landmark, list, table, and form structure meaningful.
- Use ARIA only when native semantics cannot express the interaction.

## Keyboard and Focus

- Make every interactive outcome available from the keyboard.
- Keep focus visible and move it only for a deliberate workflow reason.
- Preserve natural Tab order unless a recognized composite-widget pattern requires otherwise.
- Return focus after temporary layered interactions when the workflow continues at the trigger.
- Do not trap focus outside a modal interaction.

## Content and State

- Communicate status, errors, selection, and progress without relying on color alone.
- Announce asynchronous changes only when users need them to continue.
- Associate validation errors with fields and keep actionable failures visible.
- Provide text alternatives that convey the purpose of meaningful non-text content.

## Visual and Input

- Preserve content and operation at supported zoom and text spacing.
- Maintain sufficient contrast for text, controls, focus indicators, and meaningful graphics.
- Keep pointer targets usable without making adjacent actions ambiguous.
- Respect reduced-motion and other user preferences.

## Interactive Patterns

- Expose a sortable column header as a native `button` inside the header cell and set `aria-sort` on the cell; a click handler on the cell alone is not keyboard operable.
- Use the native modal `dialog` focus containment and inertness; do not add a document-level Tab handler that duplicates or fights it.
- Make a busy control inert to activation (disabled or guarded) and keep its accessible name while its content is visually hidden.
- Provide a forced-colors fallback, such as an `outline` or system-color border, whenever a focus indicator is built from `box-shadow` or `outline: none`.
- Make a tooltip dismissible with Escape, keep it visible while the pointer is over it, and reference it from the trigger through a stable `aria-describedby`.
- Let Escape and outside pointer press close only the topmost open layer; register layers in one shared stack instead of one document listener per component.
- Use `role="listbox"` and `role="option"` only with the matching selection and navigation model, including Home, End, and typeahead; do not bind value changes to unrelated keys such as PageUp or PageDown.
- Use `aria-live` regions only for changes users must perceive; mount the region before its content changes.

## Custom Widgets

- Follow the current WAI-ARIA Authoring Practices for the chosen pattern.
- Keep active item, focus, selection, value, and open state distinct.
- Support disabled, loading, empty, and dynamic-content states.
- Do not combine keyboard contracts from different widget patterns casually.

## Completion Criteria

- Every interactive outcome is available from the keyboard with visible focus.
- Controls have programmatic names, and errors and instructions are associated with their fields.
- Status, errors, and selection are perceivable without color alone.
- Layered interactions restore focus and close only the topmost layer.
- Custom widgets follow one recognized pattern and keep focus, active item, selection, and value distinct.
