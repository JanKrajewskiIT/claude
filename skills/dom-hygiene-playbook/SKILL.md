---
name: dom-hygiene-playbook
description: Wrapper reduction and DOM cleanup workflow for VelvetUi components. Use when auditing render trees, flattening markup, or exposing styling hooks without redundant wrappers.
---

Normative constraints: `rules/dom-hygiene`, `rules/css-modules`.

## Audit checklist

For every wrapper element, ask:

1. Does it carry real semantics the child cannot carry?
2. Does it compose more than one child into a layout?
3. Does it own state, focus, or measurement logic?
4. Is it a recognized reusable primitive (`Card`, `Field`, `LabelText`)?

If all four are no → wrapper is redundant; merge into the child or delete.

## Refactor sequence

1. Identify the redundant wrapper using the checklist
2. Move its `class`/`style` to the child via `classNames(...)` or a CSS custom property
3. If consumers needed to style an internal node through the wrapper, add a narrow `*Class` opt-in prop on the primitive instead
4. Delete the wrapper element and any orphaned `.module.css` rules
5. Recheck semantics, accessible names, keyboard behavior
6. Verify flattening did not drop layout styles (`display`, `gap`, `flex-direction`)

## Before finishing

- Diff the rendered DOM in the demo app, not just the JSX
- Confirm structural CSS (positioning, transforms, stacking) survived
- Confirm focus order and hit targets are unchanged
