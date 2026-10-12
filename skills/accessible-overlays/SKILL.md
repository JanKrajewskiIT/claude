---
name: accessible-overlays
description: Design, implement, or review accessible dialogs, drawers, popovers, and other layered UI surfaces. Use when the primary challenge is layer lifecycle and page interaction, including modality, focus placement or containment, Escape dismissal, return focus, outside interaction, scroll locking, portals, nesting, or overlay animation.
---

# Accessible Overlays

## Goal

- Make overlay opening, interaction, dismissal, and focus restoration predictable.
- Match semantics and modality to the actual interaction model.

## Do Not Use

- Use `accessible-composite-widgets` for item navigation, selection, and typeahead inside menus, listboxes, and comboboxes.

## Workflow

1. Classify the surface.
   - Decide whether it is modal, non-modal, or a transient popup.
   - Identify trigger, title, description, actions, and dismissal paths.
2. Verify the current accessibility pattern.
   - Consult the current WAI-ARIA Authoring Practices for the selected role.
   - Prefer native HTML semantics when they meet the requirement.
3. Plan focus before rendering.
   - Choose initial focus from task intent and content structure.
   - Define containment behavior for modal surfaces.
   - Record the element that should receive focus after close.
   - Use [`references/examples.md`](references/examples.md) for focus and nested-layer sequences.
4. Implement semantics.
   - Connect the accessible name and optional description.
   - Apply modal semantics only when background interaction is actually blocked.
   - Keep hidden or exiting content out of unintended interaction.
5. Implement dismissal.
   - Support Escape where the pattern permits dismissal.
   - Make close buttons keyboard accessible and clearly named.
   - Treat outside click as an additional path, not the only path.
6. Coordinate layers.
   - Define stacking, nested-overlay ownership, portal target, and event boundaries.
   - Prevent a child overlay event from dismissing the wrong parent.
7. Coordinate motion and lifecycle.
   - Separate visual exit from logical open state when animation requires it.
   - Restore focus after interaction has ended, not while exit state remains active.
   - Respect reduced-motion preferences.
8. Handle page effects.
   - Lock scrolling only for surfaces that require it.
   - Restore scroll and global listeners on every close and disposal path.
9. Propose validation.
   - Check keyboard-only open and close, initial focus, focus containment, return focus, nesting, reduced motion, and screen-reader naming.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation                                    | Decision                                              |
| -------------------------------------------- | ----------------------------------------------------- |
| Background must be unavailable               | Use a modal pattern and enforce modality.             |
| User must continue interacting with the page | Use a non-modal surface.                              |
| Trigger is removed before close              | Restore focus to the nearest logical workflow target. |
| Overlay contains another overlay             | Give the topmost layer dismissal and focus ownership. |
| Animation conflicts with reduced motion      | Reduce or remove nonessential motion.                 |

## Constraints

- Do not trap focus in non-modal content by default.
- Do not mark a surface modal while background content remains interactive.
- Do not rely on pointer interaction for opening, operation, or dismissal.
- Do not restore focus to a detached or hidden element.

## Completion Criteria

- Role, name, description, and modality match visible behavior.
- Initial, contained, and returned focus follow explicit rules.
- Every global side effect is cleaned up.
- Nested layers close in the correct order.
- Proposed checks cover keyboard, assistive technology, and motion behavior.
