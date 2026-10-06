---
name: database-soft-delete
description: Design, implement, or review soft deletion in a relational persistence model. Use when records must remain stored after deletion for recovery, references, retention, or audit while disappearing from normal reads and mutations.
---

# Database Soft Delete

## Goal

- Define deletion semantics that prevent deleted rows from reappearing, changing accidentally, or violating retention, uniqueness, and relationship rules.

## Do Not Use

- Use `ef-core-persistence` for general query, tracking, and scoping work after deletion semantics are defined.
- Use `ef-core-migrations` for migration generation, review, and deployment mechanics.
- Use `ef-core-auditing` for creation and modification metadata.

## Workflow

1. Confirm soft deletion is required by recovery, retention, audit, legal, reference, or synchronization needs.
2. Define what deletion means, who can delete or restore, whether it is reversible, which operations can see deleted rows, and when purge occurs.
3. Choose one authoritative marker.
   - Prefer a nullable deletion timestamp when time matters and add actor or reason only when required.
4. Apply the owning migration skill and analyze rows, indexes, unique constraints, foreign keys, query plans, and rolling deployment compatibility.
5. Map the marker using repository conventions and an injected time source when application code assigns it.
   - Keep deletion separate from a business status unless the domain explicitly owns that lifecycle.
6. Exclude deleted rows from every normal read and mutation path.
   - Inventory queries, joins, counts, exports, and background jobs when no reliable central mechanism exists.
7. Implement deletion as an idempotent transition and prevent later updates from reactivating the row accidentally.
8. Design restore and purge separately and recheck uniqueness, referential integrity, retention, authorization, and emitted events.
9. Propose real persistence validation for all applicable lifecycle paths.

## Decision Rules

| Situation | Decision |
|---|---|
| No recovery, retention, or reference need exists | Prefer hard deletion. |
| Deleted rows must retain deletion time | Use a timestamp rather than paired booleans. |
| A unique value may be reused | Define lifecycle-aware uniqueness explicitly. |
| Administrators need deleted rows | Provide a separately authorized query path. |

## Constraints

- Do not add soft deletion speculatively.
- Do not rely on callers to remember filtering without an enforced mechanism or complete inventory.
- Do not expose deleted records through normal find, list, count, update, or relationship traversal paths.
- Do not treat a mutable deletion timestamp as a complete audit trail.
- Stop when recovery, retention, purge, or restoration lacks an owner decision.

## Completion Criteria

- Deletion, visibility, restoration, retention, and purge semantics are explicit.
- Normal reads and mutations consistently exclude deleted rows.
- Constraints, indexes, foreign keys, and query plans support the lifecycle.
- Repeated deletion and concurrent update behavior are deterministic.
- Integration evidence proves deleted rows do not reappear through supported paths, or the required checks are reported as unrun with exact commands.
