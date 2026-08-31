---
name: frontend-form-state
description: Design, implement, or review state and validation for a single-page frontend form. Use when coordinating field values, touched and dirty state, client and server validation, asynchronous submission, reset behavior, or accessible error presentation outside a multi-step wizard.
---

# Frontend Form State

## Goal

- Keep editable values, validation, and submission behavior predictable and accessible.
- Preserve user input across recoverable failures without creating duplicate sources of truth.

## Workflow

1. Define the form contract.
   - List editable fields, initial values, dependencies, normalization, and submission payload.
   - Separate omitted, empty, null, and default values deliberately.
2. Assign ownership.
   - Keep one canonical editable draft for the form lifecycle.
   - Derive dirty and validity state when they can be computed reliably.
   - Keep server-owned data outside the draft until explicitly copied for editing.
3. Choose validation timing.
   - Validate syntax and local constraints near the field.
   - Validate cross-field rules against the complete draft.
   - Revalidate server rules through submission or an explicit remote check.
4. Normalize boundaries.
   - Preserve useful editing states while the user types.
   - Normalize values when comparing, validating, or creating the API payload.
5. Present errors.
   - Associate field errors programmatically with their controls.
   - Keep a submission summary when errors span fields or the whole request.
   - Move focus to the first useful correction target after failed submission.
6. Coordinate submission.
   - Prevent unintended duplicate submissions.
   - Preserve values after validation, conflict, and transient failures.
   - Map server field errors to stable form field paths.
7. Reset intentionally.
   - Distinguish reset to initial values, reset to last saved values, and clear.
   - Update the baseline after acknowledged saves when editing continues.
8. Propose validation.
   - Check keyboard submission, field and form errors, duplicate submit, failure recovery, reset, and payload normalization.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation | Decision |
|---|---|
| Value is temporarily incomplete while typing | Preserve it in the draft and validate without destructive coercion. |
| Rule depends on multiple fields | Validate against the complete draft. |
| Server rejects one field | Map the error to that field and keep the entered value. |
| Server rejects the whole operation | Show a persistent form-level error. |
| Form spans multiple coordinated steps | Use `multi-step-form`. |
| Form requires continuous remote persistence | Use `document-autosave`. |

## Constraints

- Do not maintain independent writable copies of the same field.
- Do not erase user input after a recoverable failure.
- Do not disable submission as the only way to communicate invalid state.
- Do not announce errors that are not visible or actionable.
- Do not persist sensitive fields without an explicit security design.

## Completion Criteria

- Every editable value has one owner.
- Validation timing and error ownership are explicit.
- Submission failures preserve a recoverable draft.
- Reset behavior returns to a defined baseline.
- Proposed checks cover keyboard, accessibility, normalization, and failures.