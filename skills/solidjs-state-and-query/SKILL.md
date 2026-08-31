---
name: solidjs-state-and-query
description: Design, implement, or review state and remote-data flows in SolidJS applications. Use when the primary outcome is assigning state ownership or managing general query and cache behavior with signals, stores, persisted preferences, query keys, mutations, invalidation, optimistic updates, or API-boundary mapping.
---

# SolidJS State and Query

## Goal

- Give each value one clear owner and source of truth.
- Keep local reactivity, persisted preferences, and server cache separate.

## Workflow

1. Classify each value.
   - Use local state for transient interaction and editable drafts.
   - Use persisted state only for preferences that must survive reloads.
   - Use the query cache for server-owned data.
2. Locate ownership.
   - Keep state near the smallest feature boundary that coordinates it.
   - Reuse repository query factories and stores when their semantics match.
3. Model local state.
   - Use signals for focused scalar values.
   - Use stores for structured state with granular updates.
   - Derive values directly or with pure memos instead of synchronizing copies with effects.
4. Model remote reads.
   - Build query keys from every normalized input that changes the request or response.
   - Read reactive inputs inside the query library's tracked configuration boundary.
   - Gate requests explicitly when required inputs are missing.
   - Use [`references/examples.md`](references/examples.md) for key, invalidation, and optimistic-update patterns.
5. Model writes.
   - Normalize payloads at the API boundary.
   - Define success, expected failure, retry, and concurrency behavior.
   - Use optimistic updates only with an explicit snapshot and rollback path.
6. Reconcile the cache.
   - Update known results directly or invalidate the narrowest affected key family.
   - Avoid broad invalidation without evidence that multiple resources changed.
7. Persist selectively.
   - Namespace keys by application and feature.
   - Export shared keys as named constants instead of repeating string literals.
   - Define an explicit initial value at the persistence boundary.
   - Version or migrate stored shapes that can evolve.
   - Give redirect or session handoff data an explicit lifetime and cleanup path.
   - Never persist secrets or sensitive server responses by default.
8. Propose validation.
   - Check request gating, query-key changes, mutation success and failure, rollback, invalidation, and reload behavior.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Value | Owner |
|---|---|
| Open state, focus, transient selection | Local signal or store |
| Unsaved editable input | Local draft |
| Reload-stable user preference | Persisted local state |
| Data returned and owned by a service | Query cache |
| Pure transformation of reactive values | Derived function or memo |

## Constraints

- Do not copy query results into writable local state without a draft or snapshot requirement.
- Do not use effects for pure derivation.
- Do not omit a request-shaping input from its query key.
- Do not let transport models spread through presentation code when mapping clarifies the boundary.

## Completion Criteria

- Every value has one intentional owner.
- Query keys fully describe their requests.
- Mutations define cache reconciliation and failure behavior.
- Persisted values are namespaced, safe, and evolvable.
- Proposed focused checks cover reactive and failure paths.
