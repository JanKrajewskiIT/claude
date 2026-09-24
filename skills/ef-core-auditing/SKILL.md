---
name: ef-core-auditing
description: Implement or review Entity Framework Core creation and modification auditing. Use when adding created or modified timestamps, actor identity, SaveChanges interception, background actor attribution, audit-column migrations, or persistence-level auditing tests.
---

# EF Core Auditing

## Goal

- Record trustworthy creation and modification metadata without confusing mutable persistence auditing with immutable business history.

## Workflow

1. Inspect `DbContext` ownership, entity conventions, interceptors, authentication context, background writers, time abstraction, migrations, and integration tests.
2. Define required timestamps, actor identity, background attribution, trust boundary, and whether values are application- or database-generated.
   - Stop when attribution or identity contracts are missing.
3. Define the creation and modification metadata owned by this persistence mechanism.
4. Choose one owning mechanism for population, such as an overridden `SaveChanges` path, `SaveChangesInterceptor`, repository convention, or database generation.
   - Avoid competing mechanisms that can overwrite each other.
5. Resolve actors from trusted request context and define explicit system actors for jobs, message handlers, migrations, and other background writes.
6. Use `TimeProvider` or the repository's clock abstraction when application code assigns timestamps.
   - Keep framework-populated fields compatible with new-entity detection and database defaults.
7. Apply `ef-core-migrations` for types, timezone semantics, nullability, defaults, backfill, and rolling deployment compatibility.
8. Keep optimistic-concurrency tokens separate from audit metadata and private unless an API concurrency contract exposes them.
9. Propose real-database validation for creation, update, background writes, unchanged entities, callback registration, and stable creation metadata.

## Decision Rules

| Situation | Decision |
|---|---|
| A valid write has no user principal | Record the declared system actor or permitted absence. |
| Database generates timestamps | Treat generated values and refresh behavior as part of the persistence contract. |
| Detached or bulk operations bypass normal callbacks | Verify them separately and define how auditing is preserved. |
| Actor identifiers are sensitive or internal | Keep them out of public contracts unless explicitly authorized. |

## Constraints

- Do not populate framework-owned audit fields manually in individual handlers.
- Do not treat mutable audit columns as tamper-evident history.
- Do not derive actor identity from untrusted headers or request values.
- Do not let multiple interceptors or database defaults silently compete for ownership.
- Do not expose internal actor IDs or versions without an API requirement.
- Do not execute migrations or access databases without explicit authorization.

## Completion Criteria

- One mechanism owns auditing for the intended `DbContext` paths.
- Actor resolution uses trusted context and background writes have intentional attribution.
- Creation metadata remains stable while modification metadata changes correctly.
- Schema, model configuration, generated values, and time semantics agree.
- Real persistence evidence proves auditing executes on every supported write path.
