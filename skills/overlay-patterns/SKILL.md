---
name: overlay-patterns
description: Shared overlay guidance for dialogs, drawers, popovers, and similar interactive surfaces in VelvetUi. Use when building or refactoring focus-managed overlays.
---

> Type: Skill (operational playbook)
> Source of truth: Rules define mandatory constraints; skills describe execution patterns.

Use this playbook for overlays and other focus-managed floating surfaces.

## Shared Overlay Pattern

Overlays should usually combine:

- `useEscapeKey` for keyboard dismissal
- `useFocusTrap` for contained keyboard navigation
- `useOverlayAnimation` for enter and exit transitions
- `classNames()` for conditional class composition
- `Heading` for titles
- `IconButton` for close actions

## Interaction Expectations

- Plan the open flow, close flow, and return-focus target together
- Treat keyboard operation as part of the component design, not post-fix polish
- Use shared focus and escape-key hooks so the interaction stays consistent across overlay families

## Rendering Guidance

- Keep open and close mechanics localized to the overlay component
- Avoid extra wrapper layers around the main surface unless they add layout, semantics, or behavior
- Keep overlay structure predictable: backdrop, positioned surface, title area, content area, actions when needed

## Styling Guidance

- Keep interaction-critical structure in the overlay module
- Put shared spacing, radius, shadow, and motion on tokens and reusable classes
- Avoid host-level CSS that reskins overlay internals in ad hoc ways
