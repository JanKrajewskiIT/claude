---
name: overlay-patterns
description: Shared overlay guidance for dialogs, drawers, popovers, and similar interactive surfaces in VelvetUi. Use when building or refactoring focus-managed overlays.
---

## Shared overlay pattern

Overlays usually combine:

- `useEscapeKey` — keyboard dismissal
- `useFocusTrap` — contained keyboard navigation
- `useOverlayAnimation` — enter/exit transitions
- `classNames()` — conditional class composition
- `Heading` for titles, `IconButton` for close actions

## Interaction expectations

- Plan open flow, close flow, return-focus target together
- Treat keyboard operation as part of the design, not post-fix polish
- Use shared focus and escape-key hooks so interaction stays consistent across overlay families

## Rendering

- Open/close mechanics localized to the overlay component
- Avoid extra wrapper layers around the main surface unless they add layout, semantics, or behavior
- Keep structure predictable: backdrop → positioned surface → title → content → actions

## Styling

- Interaction-critical structure stays in the overlay module
- Shared spacing, radius, shadow, motion → tokens and reusable classes
- No host-level CSS reskinning overlay internals ad hoc
