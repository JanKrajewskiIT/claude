---
paths:
  - '**/*'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# EF Core Persistence

## Read Paths

- Use `AsNoTracking()` on read paths unless tracked entities are genuinely required
- Prefer projection-first queries that select directly into response or intermediate models
- Avoid broad `Include` chains when a narrower projection can express the result more clearly
- Be alert to N+1 patterns when traversing child collections or issuing per-row lookups

## Write Paths

- Keep write handlers focused on one use case and one unit of work
- Load only the data needed to validate and perform the write
- Persist explicit state changes; avoid hidden side effects spread across unrelated infrastructure code

## Boundaries

- Entity configuration, migrations, and context wiring belong in infrastructure
- Business decisions, filtering rules, and orchestration should stay in handlers or domain logic, not in EF configuration
- Seed data and migrations should be intentional and reviewable, not incidental fallout from unrelated changes

## Audit and User Scoping

When the project's shared infrastructure provides an audit base entity + interceptor (see `dotnet-shared-infrastructure`):

- User-scoped entities MUST inherit the shared `AuditEntity` (or equivalent); this auto-applies a `HasQueryFilter(e => e.CreatedBy == CurrentUserId)` on every DbSet through the shared `BaseApplicationDbContext`
- NEVER set `CreatedBy` / `CreatedOn` / `ModifiedBy` / `ModifiedOn` manually — the audit interceptor stamps them on `SaveChanges`
- Audit entities use `builder.ToAuditTable("<table>")`; non-audit entities use `builder.ToBasicTable("<table>")`. Never call `builder.ToTable(...)` directly when these helpers exist
- Resolve the current user with `ICurrentUserService`; design-time uses the matching `DesignTimeCurrentUserService` so query filters compile under `dotnet ef`
- Entity configurations are `internal sealed class : IEntityTypeConfiguration<T>`, auto-discovered by the base context

## Postgres Specifics

- JSONB columns: `.HasColumnType(PostgresCommandConsts.JsonDataType)` (or the project's equivalent constant) — never the literal `"jsonb"`
- At-rest encryption for tokens/secrets: `.HasConversion(new EncryptedStringConverter(encryptionKey))` (AES-256-GCM)
- Postgres enums must be declared in `Domain/Enums/` and registered in THREE places that MUST stay in sync:
  1. `Program.cs` Aspire `AddPostgresDbContext` callback (`MapEnum<T>(...)`)
  2. `ApplicationDbContext.ConfigureModel` (`HasPostgresEnum<T>(...)`)
  3. `DesignTimeDbContextFactory` (`MapEnum<T>` on both `dataSourceBuilder` and `npgsqlOptions`)

## Migrations Workflow

- Migrations applied at startup via the shared `MigrateDatabase<ApplicationDbContext>(ct)` helper in the bootstrap `beforeRun` callback
- Each service owns its own `Migrations/` folder
- Migrations are NOT historical artifacts; rebases happen freely. Do not preserve old migrations as "audit"
- Every service requires a `DesignTimeDbContextFactory` for the EF CLI; mirror the existing one (localhost / postgres / postgres + the shared design-time current-user service)
- `dotnet ef migrations add <Name>` is run from inside `<Service>.Api`
