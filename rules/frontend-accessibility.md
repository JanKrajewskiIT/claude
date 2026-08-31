# Frontend Accessibility

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

## Custom Widgets

- Follow the current WAI-ARIA Authoring Practices for the chosen pattern.
- Keep active item, focus, selection, value, and open state distinct.
- Support disabled, loading, empty, and dynamic-content states.
- Do not combine keyboard contracts from different widget patterns casually.