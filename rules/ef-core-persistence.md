---
paths:
  - '**/*'
---

# EF Core Persistence

## Read paths

- `AsNoTracking()` unless tracked entities are genuinely required
- Projection-first queries selecting directly into response/intermediate models
- Avoid broad `Include` chains when a narrower projection works
- Watch for N+1 patterns when traversing child collections

## Write paths

- One handler = one use case = one unit of work
- Load only what's needed to validate and perform the write
- Persist explicit state changes; no hidden side effects across infrastructure

## Boundaries

- Entity configuration, migrations, context wiring → infrastructure
- Business decisions, filtering, orchestration → handlers/domain, not EF configuration
- Seed data and migrations are intentional, not incidental fallout

## Audit & user scoping

When the project ships a base entity hierarchy + audit interceptor (see `dotnet-shared-infrastructure`):

- Two-tier hierarchy: `BaseEntity` (abstract, `Guid Id { get; init; }`) is root; `AuditEntity : BaseEntity` adds `CreatedBy`/`CreatedOn`/`ModifiedBy`/`ModifiedOn`
- User-scoped entities MUST inherit `AuditEntity`; this auto-applies `HasQueryFilter(e => e.CreatedBy == CurrentUserId)` on every DbSet via the shared `BaseApplicationDbContext`
- Non-user-scoped entities (lookups, system data) inherit `BaseEntity` directly
- NEVER set `CreatedBy`/`CreatedOn`/`ModifiedBy`/`ModifiedOn` manually — the audit interceptor stamps them
- Audit entities use `builder.ToAuditTable("<table>")`; non-audit use `builder.ToBasicTable("<table>")`. Never call `builder.ToTable(...)` directly when these helpers exist (they wire PK + audit columns + `CURRENT_TIMESTAMP` defaults)
- Resolve current user with `ICurrentUserService` (NEVER `ICurrentUserContext` or other variants); design-time uses `DesignTimeCurrentUserService`
- Entity configurations are `internal sealed class : IEntityTypeConfiguration<T>`, auto-discovered by the base context

## Postgres specifics

- JSONB columns: `.HasColumnType(PostgresCommandConsts.JsonDataType)` — never literal `"jsonb"`
- Length constants from shared infrastructure (`DataTypeConsts.NameLength`, `DataTypeConsts.TextLength`) used in BOTH `HasMaxLength(...)` AND the matching FluentValidation rule
- At-rest encryption for tokens/secrets: `.HasConversion(new EncryptedStringConverter(encryptionKey))` (AES-256-GCM)
- Postgres enums declared in `Domain/Enums/` and registered in THREE places that MUST stay in sync:
  1. `Program.cs` Aspire `AddPostgresDbContext` callback (`MapEnum<T>(...)`)
  2. `ApplicationDbContext.ConfigureModel` (`HasPostgresEnum<T>(...)`)
  3. `DesignTimeDbContextFactory` (`MapEnum<T>` on both `dataSourceBuilder` and `npgsqlOptions`)

## Migrations workflow

- Applied at startup via shared `MigrateDatabase<ApplicationDbContext>(ct)` in the bootstrap `beforeRun`
- Each service owns its own `Migrations/` folder
- Migrations are NOT historical artifacts; rebases happen freely. Do not preserve old migrations as "audit"
- Every service requires a `DesignTimeDbContextFactory` (mirror existing: localhost / postgres / postgres + shared design-time current-user service)
- `dotnet ef migrations add <Name>` is run from inside `<Service>.Api`
