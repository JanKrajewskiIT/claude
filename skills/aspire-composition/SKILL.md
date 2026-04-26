---
name: aspire-composition
description: .NET Aspire AppHost workflow — adding a new service, database, secret, gateway route, or cross-service HTTP call. Use when modifying *.AppHost or service Program.cs.
---

> Type: Skill (operational playbook)

Use this playbook when changing the Aspire `*.AppHost` orchestrator, adding a new service, wiring a database, introducing a cross-service HTTP call, or adding a secret.

Normative constraints live in `aspire-composition`, `dotnet-vertical-slice`, `dotnet-shared-infrastructure`, and `security-boundaries`.

## Adding a New Service

1. Create `<Service>.Api/` with `Program.cs` calling the project's standard bootstrap entrypoint (e.g. `await RunModuleAsync(args, configureServices, configureApp, beforeRun)`)
2. In `configureServices`, register feature handlers via the assembly-scan helper and call `builder.AddPostgresDbContext<ApplicationDbContext>("<resource-name>")` (or equivalent for other DBs)
3. In `beforeRun`, run migrations via `await services.MigrateDatabase<ApplicationDbContext>(ct)`
4. In `*.AppHost/AppHost.cs`:
   - `var <db> = postgres.AddDatabase("<resource-name>");`
   - `var <serviceVar> = builder.AddProject<Projects.<Service>_Api>("<service-name>")` then chain `.WithEnvironment(...)` for required config, `.WithHttpHealthCheck("/health")`, `.WithReference(<db>)`, `.WaitFor(<db>)`
5. Add the gateway (e.g. YARP) route group for the service prefix
6. Add the OpenAPI explorer reference (e.g. `WithApiReference(<serviceVar>)`)
7. Update the solution file to include the new csproj

## Adding a Cross-Service HTTP Call

1. Register the bearer-forwarding HTTP message handler (e.g. `AuthTokenForwardingHandler`) as transient in the calling service
2. Configure a named `IHttpClientFactory` client with `BaseAddress = new Uri("https+http://<target-service-name>")`
3. Add the handler: `.AddHttpMessageHandler<AuthTokenForwardingHandler>()`
4. Inject `IHttpClientFactory` (or a typed client) into the handler that calls out

## Adding a Secret

1. Add `var <name> = builder.AddParameter("<name>", secret: true);` near the top of `AppHost.cs`
2. Pass to the consuming service via `.WithEnvironment("<DotnetConfig__Path>", <name>)`
3. Bind to a strongly-typed options class via the project's standard options helper

## Adding a Postgres Enum

Register at all three sites listed in `rules/ef-core-persistence` "Postgres Specifics" (Program.cs / ApplicationDbContext / DesignTimeDbContextFactory) — they MUST stay in sync. Then add the migration: `dotnet ef migrations add <Name>` from `<Service>.Api`.

## Before Finishing

- Verify the new service appears under `dotnet run` against the AppHost and `/health` is green
- Check the gateway routes the prefix correctly (`/<area>` -> `<service>-api`)
- Confirm the OpenAPI explorer lists the new API
- Confirm the database resource name in `AppHost.cs` matches the string used in `AddPostgresDbContext<>("...")`
