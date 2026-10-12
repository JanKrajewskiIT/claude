---
name: ef-core-persistence
description: Design, implement, optimize, or review Entity Framework Core read and write paths. Use when working with DbContext, LINQ queries, tracking, projections, relationships, transactions, concurrency, tenant or user scoping, audit fields, interceptors, bulk operations, or database performance outside migration generation.
---

# EF Core Persistence

## Goal

- Make each persistence operation correct, bounded, and explicit about tracking, scope, concurrency, and transactions.
- Keep database mechanics from leaking into domain and transport contracts.

## Do Not Use

- Use `ef-core-migrations` for generating, reviewing, or deploying schema migrations.
- Use `ef-core-auditing` for trusted creation and modification metadata.
- Use `ef-core-value-conversion` for storage representations of non-primitive properties.
- Use `database-soft-delete` for deletion, restoration, retention, and purge lifecycle design.
- Use `api-contract-design` for consumer-visible HTTP contracts.

## Workflow

1. Locate persistence ownership.
   - Identify the `DbContext`, provider, entity configuration, transaction boundary, and repository conventions.
   - Reuse established scoping, audit, encryption, and interception infrastructure.
2. Define the operation.
   - List required inputs, selected data, expected cardinality, authorization scope, and consistency needs.
   - Separate business decisions from query and mapping mechanics.
3. Design a read path.
   - Use no-tracking behavior when entities will not be updated.
   - Project only required fields into application or response models.
   - Define deterministic ordering before pagination.
   - Inspect navigation access for N+1 queries and unnecessary cartesian expansion.
4. Design a write path.
   - Load only state required to validate and apply the change.
   - Apply one use case within one intentional unit of work.
   - Keep generated, audited, and intercepted values under their owning mechanism.
   - Apply `ef-core-auditing` when creation or modification metadata requires trusted actor and time ownership.
5. Protect scope.
   - Enforce tenant, user, soft-delete, and resource ownership consistently.
   - Treat query filters as defense in depth, not a substitute for authorization.
   - Make any filter bypass explicit and narrowly reviewed.
6. Handle concurrency and transactions.
   - Use optimistic concurrency when multiple writers may overwrite the same state.
   - Keep transactions as short as practical.
   - Coordinate external side effects through an established outbox or post-commit mechanism when atomicity matters.
7. Review provider behavior.
   - Verify translation, null semantics, collations, indexes, data types, and transaction behavior for the configured provider.
   - Avoid client evaluation and provider-specific SQL unless the benefit and compatibility cost are explicit.
   - Apply `ef-core-value-conversion` when non-primitive properties require an explicit storage representation or structural comparison.
8. Coordinate schema impact.
   - Use `ef-core-migrations` when the model change requires a schema, data, enum, index, or constraint migration.
   - Keep runtime persistence code independent of historical migration implementation.
   - Apply `database-soft-delete` when retained deleted rows require lifecycle-wide query, constraint, restore, or purge behavior.
9. Propose validation.
   - Check generated queries, cardinality, scope isolation, concurrency conflicts, transaction behavior, cancellation, and representative data volume.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation                                       | Decision                                                |
| ----------------------------------------------- | ------------------------------------------------------- |
| Result is read-only                             | Use no-tracking behavior.                               |
| Consumer needs a subset of fields               | Project at the database boundary.                       |
| Related data creates a broad object graph       | Prefer a focused projection or explicit split strategy. |
| Multiple writers can update the row             | Add and handle an optimistic concurrency token.         |
| Operation spans database and external messaging | Use the established consistency mechanism.              |
| Model shape changes storage                     | Apply `ef-core-migrations`.                             |

## Constraints

- Do not expose tracked entities as transport contracts.
- Do not use broad `Include` chains when a focused projection satisfies the operation.
- Do not disable global filters casually.
- Do not claim atomicity across systems without an explicit consistency design.
- Do not add a repository abstraction unless the codebase already requires or benefits from it.

## Completion Criteria

- Read and write paths select and mutate only required state.
- Tracking, scoping, concurrency, and transaction behavior are explicit.
- Provider translation and expected query shape are understood.
- Schema changes are delegated to an intentional migration workflow.
- Proposed checks cover isolation, conflicts, cancellation, and realistic volume.
