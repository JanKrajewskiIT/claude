---
name: multi-step-form
description: Design, implement, or review accessible multi-step forms and wizards. Use when coordinating step navigation, per-step validation, drafts, conditional steps, review screens, submission, resume behavior, or progress indicators.
---

# Multi-Step Form

## Goal

- Make progress, validation, persistence, and submission behavior deterministic.
- Keep one owner for form data and navigation state.

## Workflow

1. Define the journey.
   - List steps, required outcomes, dependencies, conditional branches, and final submission.
   - Use multiple steps only when grouping reduces cognitive or operational load.
2. Define state ownership.
   - Keep canonical form data outside individual step lifecycles.
   - Separate current step, visited steps, validation state, draft status, and submission state.
   - Derive completion from data and rules instead of storing duplicate flags.
3. Define navigation.
   - Specify when users can move forward, backward, jump, cancel, or resume.
   - Preserve entered values when steps unmount or become temporarily hidden.
   - Re-evaluate downstream steps when an earlier answer changes the path.
4. Define validation.
   - Validate fields at the point of useful correction.
   - Validate the current step before forward navigation when later steps depend on it.
   - Validate the complete payload before final submission.
5. Define accessibility.
   - Use a semantic form and real controls.
   - Give the current step a clear heading and progress text.
   - Move focus to the new step heading or first invalid field after navigation.
   - Announce validation and asynchronous submission outcomes.
6. Define draft behavior.
   - Decide whether drafts are local, remote, or absent.
   - Define save timing, restoration, expiry, schema version, and sensitive-field exclusions.
   - Use `document-autosave` when remote background persistence is required.
7. Define submission.
   - Normalize one final payload at the API boundary.
   - Prevent duplicate submission and preserve retry-safe state after failure.
   - Distinguish validation, conflict, transient, and terminal failures.
8. Implement the coordinator.
   - Keep navigation and cross-step decisions in one form coordinator.
   - Keep step components focused on fields and step-local presentation.
   - Use [`references/examples.md`](references/examples.md) for a neutral state model.
9. Propose validation.
   - Check linear and conditional paths, backward edits, reload, draft restore, keyboard flow, validation focus, duplicate submit, and failures.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation                                                                             | Decision                                             |
| ------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| Sections remain visible in one form without guarded navigation or separate lifecycles | Use `frontend-form-state`.                           |
| Steps have no meaningful grouping or dependency                                       | Prefer one form.                                     |
| Later steps depend on current answers                                                 | Validate before moving forward.                      |
| Earlier edit removes a conditional step                                               | Remove or deliberately retain now-inapplicable data. |
| Submission can be retried                                                             | Make duplicate prevention and idempotency explicit.  |
| Draft contains secrets or payment data                                                | Do not persist it by default.                        |

## Constraints

- Do not use step components as independent sources of truth.
- Do not mark a step complete solely because it was visited.
- Do not block backward navigation to conceal invalid state.
- Do not rely on color alone to communicate progress or errors.
- Do not persist sensitive fields without a specific security design.

## Completion Criteria

- One coordinator owns data, path, validation, and submission state.
- Every navigation transition has explicit guards and focus behavior.
- Conditional paths handle stale data intentionally.
- Draft and submission failures preserve recoverable user work.
- Proposed checks cover all meaningful routes through the form.
