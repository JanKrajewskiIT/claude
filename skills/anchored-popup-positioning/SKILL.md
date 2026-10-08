---
name: anchored-popup-positioning
description: Position dropdowns, popovers, tooltips and menus next to an anchor with viewport flip, shift and clipping-safe placement, without a positioning library. Use when panels are cut off by overflow containers, must flip near viewport edges, or an external positioning dependency is not allowed.
---

# Anchored Popup Positioning

## Goal

- Place an anchored panel inside the viewport, keep it attached while the page changes, and keep focus order and outside-click containment intact.

## When To Use

- Selects, comboboxes, popovers, tooltips and menus open inside dialogs, tables or scrolling panels.
- Panels open at fixed sides and collide with viewport edges.

## Do Not Use

- Modal layers, focus containment and return focus: use `accessible-overlays`. The positioning hook only places a panel; layering and dismissal stay there.
- Item navigation inside menus and listboxes: use `accessible-composite-widgets`.

## Workflow

1. Choose the strategy.

   | Situation | Strategy |
   |---|---|
   | Panel holds interactive content or must stay in tab order | Fixed positioning in place, no portal. |
   | Panel is non-interactive and clipped by an ancestor with its own containing block | Fixed positioning with containing-block compensation. |
   | Layer must escape stacking contexts entirely | Portal, and extend outside-click handling to the portal root. |
   | Target browsers support native anchor positioning | Verify support in primary documentation before choosing it. |

2. Write a pure placement function.
   - Inputs: anchor box, panel size, viewport size, side, alignment, offset, edge padding.
   - Flip to the opposite side only when the preferred side overflows and the opposite overflows less.
   - Slide along the cross axis, then clamp to the viewport.
   - Return coordinates and the side used.
   - Use [`references/algorithm.md`](references/algorithm.md).
3. Compensate for containing blocks.
   - Walk the ancestors; the first with transform, perspective, filter, backdrop filter, contain or matching will-change defines the origin of fixed positioning.
   - Subtract that ancestor's padding-box origin from the coordinates.
4. Write one hook.
   - Signature: open accessor, anchor accessor, options for side, align, offset, padding and match width.
   - Return a ref setter, an inline style accessor and the resolved side accessor.
   - Measure immediately when opened, then on scroll in capture phase, on resize and through a `ResizeObserver` on panel and anchor, batched by animation frame.
   - Disconnect observers and cancel frames on cleanup, with the owner rules of the SolidJS conventions.
5. Apply to components.
   - Pass the ref and inline style to the panel.
   - Set position fixed, left, top, right and bottom auto, and transform none inline, so component CSS offsets stop applying.
   - Drive side modifier classes, such as transform origin and hover bridges, from the resolved side.
   - Match the anchor width for select-like lists.
   - Remove component-local flip logic.
6. Keep accessibility.
   - Keep the panel inside the anchor's wrapper so outside-click and Escape handling still work.
   - Keep ARIA relationships unchanged.
7. Validate.
   - Propose a manual matrix: panel near each viewport edge, inside a scrolling dialog, inside a transformed ancestor, while scrolling and resizing, with reduced motion.
   - Report the matrix as unrun unless executed.

## Constraints

- Do not add a positioning dependency without approval.
- Do not clamp panel height unless required; document the limitation.
- Do not leave a stale `opensUp` style state next to the hook.

## Output

- Placement function, hook, updated components, a note on strategy and limits.

## Completion Criteria

- Placement logic exists once and components do not duplicate it.
- Panels flip, shift and follow scrolling without clipping in the tested matrix, or the matrix is reported as unrun.
- Listeners and observers are cleaned up.
