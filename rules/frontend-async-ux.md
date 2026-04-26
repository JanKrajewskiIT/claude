---
paths:
  - '**/*'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# Frontend Async UX

## Required Async States

- Every request-driven surface should handle `loading`, `success`, `empty`, and `error` intentionally when those states are possible
- Do not leave users with blank areas or unexplained stale UI while async work is happening
- Empty state should be distinct from error state

## Mutations

- User-triggered mutations should expose pending state in the UI
- Failed mutations should surface a visible error path; do not fail silently
- Success should produce a visible result through refreshed data, closed workflow, toast, inline confirmation, or equivalent feedback
- Use optimistic updates only when rollback is straightforward and the UX benefit is clear

## Interaction Discipline

- Keep async state ownership close to the feature that renders it
- Avoid duplicating server state into ad hoc local state just to drive loading or success UI
- Prefer predictable, explicit transitions over clever hidden async behavior
