---
name: ef-core-value-conversion
description: Design, implement, or review Entity Framework Core value conversion and comparison for enums, value objects, JSON, collections, and other non-primitive properties. Use when adding ValueConverter or ValueComparer behavior, changing stored representations, or diagnosing asymmetric materialization, tracking, or query failures.
---

# EF Core Value Conversion

## Goal

- Persist non-primitive values through an explicit, compatible, and round-trip-verified storage contract without coupling database and wire representations.

## Workflow

1. Inspect the provider, column type, model property, existing converters, comparers, conventions, custom queries, migrations, and integration tests.
   - Reuse an existing representation when it preserves required semantics.
2. Define database type, null behavior, serialized shape, equality semantics, compatibility requirements, and whether deployed rows must remain readable.
3. Separate database, domain, and transport representations.
   - Do not assume display values, JSON names, or API enum values are stable persistence identifiers.
4. Implement the narrowest `ValueConverter` or model convention that preserves concrete source and provider types.
   - Avoid a broad generic convention unless every matching property shares the same storage contract.
5. Add a `ValueComparer` when mutable or structural values require snapshot, equality, or hash behavior for change tracking.
   - Prefer immutable value objects when practical.
6. Register conversion and comparison in the owning entity configuration and keep serialization mechanics at the persistence boundary.
7. Inspect query translation and raw SQL separately.
   - Custom SQL, parameters, indexes, and provider functions may use the provider representation directly or bypass conversion assumptions.
8. Preserve deployed representations through backward-compatible reads or a coordinated migration.
   - Ensure older application versions can read values written during a rolling deployment before enabling new writers.
9. Propose real-database round-trip validation for representative, null, unknown, equality, change-tracking, query, and compatibility paths.

## Decision Rules

| Situation | Decision |
|---|---|
| Database and API values have different lifecycles | Define independent representations. |
| Property contains mutable structural data | Supply an appropriate comparer or make the value immutable. |
| Existing generic JSON shape is sufficient | Reuse it and map typed domain behavior outside the entity when appropriate. |
| Stored representation changes | Plan compatible reads or an explicit data migration. |
| Query depends on converted content | Verify provider translation and index use rather than assuming converter methods run client-side. |

## Constraints

- Do not treat a unit test of converter delegates as proof that EF Core registration and provider mapping work.
- Do not silently coerce unknown stored values to a valid business value.
- Do not let a newer instance write a value an older instance in the rollout cannot read.
- Do not move serialization mechanics into the domain model merely to avoid persistence configuration.
- Do not use conversion to hide a schema change that requires migration and compatibility planning.

## Completion Criteria

- Storage representation, equality semantics, null behavior, and compatibility policy are explicit.
- Converter and comparer registration belongs to the intended model property.
- Query and raw-SQL paths use the intended provider representation.
- A real-database round trip proves materialization, writing, tracking, and registration.
- Incompatible values fail diagnostically rather than becoming incorrect domain values.

