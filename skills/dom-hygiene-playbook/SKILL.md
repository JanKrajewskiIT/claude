---
name: dom-hygiene-playbook
description: Wrapper reduction and DOM cleanup workflow for VelvetUi components. Use when auditing render trees, flattening markup, or exposing styling hooks without redundant wrappers.
---

> Type: Skill (operational playbook)

Use this playbook when adding, auditing, or refactoring component structure. Normative constraints live in `rules/dom-hygiene` and `rules/css-modules` — do not restate them here.

## Audit Checklist

For every wrapper element in the render tree, ask:

1. Does it carry real semantics that the child cannot carry?
2. Does it compose more than one child into a layout?
3. Does it own state, focus, or measurement logic?
4. Is it a recognized reusable primitive such as `Card`, `Field`, or `LabelText`?

If the answer to all four is no, the wrapper is probably redundant — merge it into the child or delete it.

## Refactor Sequence

1. Identify the redundant wrapper using the checklist above
2. Move its `class` / `style` to the child via `classNames(...)` or a CSS custom property
3. If consumers needed to style an internal node through the wrapper, add a narrow `*Class` opt-in prop on the primitive instead
4. Delete the wrapper element and any orphaned `.module.css` rules
5. Recheck semantics, accessible names, and keyboard behavior
6. Verify that flattening did not drop layout styles such as `display`, `gap`, or `flex-direction`

## Before Finishing

- Diff the rendered DOM in the demo app, not just the JSX
- Confirm structural CSS (positioning, transforms, stacking) survived the refactor
- Confirm focus order and hit targets are unchanged
