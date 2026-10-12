---
name: dom-hygiene-audit
description: Audit, simplify, or review rendered frontend markup without changing behavior. Use when reducing redundant wrappers, flattening component trees, moving semantics or layout to the correct element, removing orphaned styles, or checking whether DOM complexity is justified.
---

# DOM Hygiene Audit

## Goal

- Keep rendered markup as shallow as semantics, layout, and interaction permit.
- Remove redundant nodes without changing accessibility, styling, or behavior.

## Workflow

1. Inspect rendered output.
   - Evaluate the resulting DOM, not only component source.
   - Record semantics, layout ownership, focus behavior, measurement, and event boundaries.
2. Classify each wrapper.
   - Keep a wrapper that provides unique semantics, multi-child layout, state, focus, measurement, scrolling, or a reusable primitive boundary.
   - Mark a wrapper as redundant when its behavior can move to its only meaningful child.
3. Plan each removal.
   - Transfer required attributes, classes, styles, refs, and handlers deliberately.
   - Preserve accessible names, relationships, landmarks, and list or form structure.
   - Stop if the child cannot accept the required contract safely.
4. Flatten incrementally.
   - Remove one structural layer at a time.
   - Use the repository's class and style composition mechanisms.
   - Add a narrow extension point only when multiple consumers need the same internal styling boundary.
5. Clean associated code.
   - Remove orphaned selectors, props, refs, branches, and layout rules.
   - Keep structural CSS required by positioning, stacking, transforms, or animation.
6. Review conditional rendering.
   - Avoid conditional wrappers that duplicate the same child structure.
   - Preserve mounting when a component owns imperative lifecycle or exit animation.
   - Unmount deliberately when resource lifetime or performance requires it.
7. Propose validation.
   - Compare rendered structure before and after the change.
   - Check semantics, focus order, hit targets, responsive layout, stacking, animation, and accessible relationships.
   - List exact commands and ask before running them unless already approved.

## Wrapper Decision

| Wrapper responsibility                        | Decision                       |
| --------------------------------------------- | ------------------------------ |
| Unique semantic grouping                      | Keep it.                       |
| Layout for multiple children                  | Keep it.                       |
| Focus, scroll, measurement, or state boundary | Keep it.                       |
| Reusable primitive contract                   | Keep or improve the primitive. |
| Class or style for one compatible child       | Merge it into the child.       |
| No observable responsibility                  | Remove it.                     |

## Constraints

- Do not optimize source appearance while making rendered semantics worse.
- Do not move structural CSS without checking its containing-block and stacking effects.
- Do not replace meaningful list, table, form, or landmark structure with generic elements.
- Do not add broad styling escape hatches to remove one wrapper.
- Do not leave orphaned styles or public props after flattening.

## Completion Criteria

- Every remaining wrapper has an observable responsibility.
- Removed nodes leave no orphaned code or styles.
- Semantics, focus, layout, interaction, and animation remain intentional.
- Public component contracts change only when required and documented.
- Proposed checks compare rendered behavior, not only source structure.
