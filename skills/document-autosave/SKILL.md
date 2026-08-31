---
name: document-autosave
description: Design, implement, or review reliable background saving for editable documents. Use when the primary outcome is continuous persistence of user edits, including debounce, dirty tracking, save status, serialized writes, retries, offline behavior, optimistic concurrency, conflict resolution, unload protection, or draft recovery.
---

# Document Autosave

## Goal

- Preserve user work without silently overwriting newer data.
- Make pending, saved, failed, offline, and conflicting states observable.

## Workflow

1. Define document identity and ownership.
   - Identify the server document, local draft, editable fields, and excluded sensitive values.
   - Define the revision or concurrency token returned by the server.
2. Define state transitions.
   - Track clean, dirty, scheduled, saving, saved, failed, offline, and conflict states.
   - Keep the latest local revision separate from the last acknowledged server revision.
3. Detect meaningful changes.
   - Normalize values before comparing or saving.
   - Avoid writes for equivalent data and changes caused only by server hydration.
   - Increment a local sequence for each meaningful edit.
4. Schedule saves.
   - Debounce rapid edits and define a maximum delay when continuous typing must still be persisted.
   - Flush or warn on navigation only when unsaved work remains.
   - Cancel timers and subscriptions when ownership ends.
5. Serialize requests.
   - Allow at most the intended number of in-flight saves per document.
   - Never mark newer edits saved when an older request completes.
   - Queue or merge a follow-up save when edits occur during a request.
6. Protect concurrency.
   - Send the last acknowledged revision with each write.
   - Treat revision mismatch as a conflict, not a transient retry.
   - Preserve both local and remote versions until resolution.
7. Handle failures.
   - Retry transient failures with bounded backoff and jitter.
   - Pause retries while offline and resume deliberately.
   - Surface terminal failures and provide an explicit retry path.
8. Communicate status.
   - Show meaningful states without announcing every keystroke.
   - Keep error or conflict status visible until resolved.
   - Never claim "saved" before the server acknowledges the latest local revision.
9. Recover drafts.
   - Version locally persisted draft shapes.
   - Expire obsolete drafts and reconcile them against server revisions.
   - Avoid local persistence for sensitive documents unless explicitly designed.
10. Implement the protocol.
   - Keep transport, scheduling, state transitions, and UI presentation separable.
   - Use [`references/examples.md`](references/examples.md) for sequencing and conflict examples.
11. Propose validation.
   - Check rapid edits, edits during save, out-of-order responses, offline recovery, conflicts, reload, navigation, and terminal failures.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation | Decision |
|---|---|
| Edit occurs during an in-flight save | Schedule another save for the newer local revision. |
| Older response arrives after newer edits | Acknowledge only its submitted revision. |
| Server revision changed independently | Enter conflict state; do not blind-retry. |
| Network is unavailable | Retain dirty state and pause bounded retries. |
| Document contains sensitive data | Avoid local persistence unless explicitly approved. |

## Constraints

- Do not use debounce alone as the autosave state model.
- Do not allow stale responses to overwrite newer local edits.
- Do not retry authorization, validation, or conflict failures as transient errors.
- Do not hide persistent failures behind a temporary toast only.
- Do not promise unload-time network delivery.

## Completion Criteria

- Every local edit maps to an acknowledged save or a visible unresolved state.
- Stale responses cannot mark newer content saved or overwrite it.
- Conflict, offline, retry, and recovery behavior are explicit.
- Status reflects the latest local and server revisions accurately.
- Proposed checks exercise timing and concurrency, not only the success path.
