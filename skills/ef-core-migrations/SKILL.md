---
name: ef-core-migrations
description: Create, review, repair, script, or plan deployment of Entity Framework Core migrations. Use when changing an EF Core model or database schema, adding or removing migrations, preserving data, handling model snapshots, generating SQL scripts or bundles, planning rollback, or diagnosing pending model changes.
---

# EF Core Migrations

## Goal

- Evolve the database schema while preserving intended data and deployment safety.
- Keep the EF model, migration history, snapshot, and deployment artifact consistent.

## Do Not Use

- Use `ef-core-persistence` for runtime queries, tracking, transactions, and concurrency.
- Use `ef-core-value-conversion` to design a converter or comparer; return here when its stored representation changes.
- Use `database-soft-delete` to define deletion semantics before migrating them.

## Workflow

1. Inspect migration ownership.
   - Identify the `DbContext`, migrations assembly, startup project, provider, EF Core version, and deployment process.
   - Inspect recent migrations and provider-specific model configuration.
2. Define the change.
   - Separate schema operations, data transformations, constraints, indexes, and application compatibility steps.
   - Identify table size, lock duration, availability, and data-loss risks.
   - Identify every runtime, model, and design-time registration site for provider-specific types such as database enums.
   - Record expected row count, lock budget, runtime budget, rollout signal, abort condition, and recovery owner.
3. Plan compatibility.
   - Use expand-and-contract steps when old and new application versions may overlap.
   - Add nullable or compatible structures before backfilling and enforcing stricter constraints.
   - Coordinate destructive cleanup with application deployment and rollback limits.
4. Propose migration generation.
   - Use the repository's pinned EF tool and explicit target or startup projects when needed.
   - Give the migration a descriptive outcome-based name.
   - Ask before running generation because it executes a build and writes files.
5. Review generated artifacts.
   - Inspect `Up`, `Down`, designer metadata, and the model snapshot.
   - Keep provider-specific type registration synchronized across runtime and design-time contexts.
   - Replace accidental drop-and-add operations with explicit renames when data must survive.
   - Remove unrelated model changes before accepting the migration.
   - Use [`references/examples.md`](references/examples.md) for rename and staged backfill patterns.
6. Implement data movement.
   - Preserve source data until destination values are populated and verified.
   - Use fixed-data operations for known rows and provider-aware SQL for transformations based on existing data.
   - Do not use current entity types or the current `DbContext` inside historical migration logic.
7. Define rollback.
   - Implement `Down` only when the prior state can be restored safely.
   - Fail explicitly or document restore-from-backup when reversal would fabricate or lose data.
   - Never remove a migration already applied to a shared or production database.
8. Choose deployment artifact.
   - Use reviewed SQL scripts when approval, tuning, or archival is required.
   - Use migration bundles for controlled automated deployment.
   - Reserve direct CLI updates for local development unless the deployment policy explicitly permits them.
9. Protect credentials and execution.
   - Use a deployment identity with schema permissions distinct from the runtime identity where practical.
   - Supply production connections through the deployment secret store.
   - Avoid making every application replica execute migrations during startup.
10. Propose validation.
   - Check pending model changes, upgrade from the latest deployed schema, representative data preservation, clean-database creation, and rollback where supported.
   - Inspect generated SQL for destructive operations, locks, provider syntax, and transaction boundaries.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation | Decision |
|---|---|
| Property rename generated drop and add | Replace with an explicit rename operation. |
| Existing values require transformation | Use staged schema changes and backfill before cleanup. |
| Migration reached a shared database | Keep it and add a corrective migration. |
| Deployment requires SQL review | Generate a versioned SQL script. |
| Automated deployment needs a standalone artifact | Generate a migration bundle. |
| Rollback cannot reconstruct data | Require restore or a forward fix instead of unsafe `Down`. |

## Constraints

- Do not apply migrations to any database without explicit approval.
- Do not infer safety from successful scaffolding.
- Do not delete or rewrite published migration history casually.
- Do not combine `EnsureCreated` with migrations for the same relational schema.
- Do not embed production connection strings in source, scripts, or bundles.
- Do not treat successful creation of an empty database as evidence that an upgrade is safe.
- Prefer a forward repair when rollback would discard data or break writes produced by the newer application.

## Completion Criteria

- The migration contains only the intended model and data changes.
- Renames and transformations preserve required data.
- Forward, rollback, and mixed-version behavior are explicit.
- Deployment uses a reviewed artifact and controlled identity.
- Proposed checks cover both existing and clean database paths.
- Lock duration, execution time, and recovery behavior fit the documented operational budget.
