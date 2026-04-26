---
name: aspire-composition
description: .NET Aspire AppHost workflow — adding a new service, database, secret, gateway route, or cross-service HTTP call. Use when modifying *.AppHost or service Program.cs.
---

Normative constraints: `aspire-composition`, `dotnet-vertical-slice`, `dotnet-shared-infrastructure`, `security-boundaries`.

## Adding a new service

1. Create `<Service>.Api/` with `Program.cs` calling the standard bootstrap (e.g. `await RunModuleAsync(args, configureServices, configureApp, beforeRun)`)
2. In `configureServices`: register feature handlers via the assembly-scan helper and call `builder.AddPostgresDbContext<ApplicationDbContext>("<resource-name>")`
3. In `beforeRun`: `await services.MigrateDatabase<ApplicationDbContext>(ct)`
4. In `*.AppHost/AppHost.cs`:
   - `var <db> = postgres.AddDatabase("<resource-name>");`
   - `var <serviceVar> = builder.AddProject<Projects.<Service>_Api>("<service-name>")` then chain `.WithEnvironment(...)`, `.WithHttpHealthCheck("/health")`, `.WithReference(<db>)`, `.WaitFor(<db>)`
5. Add the gateway (e.g. YARP) route group for the service prefix
6. Add the OpenAPI explorer reference (`WithApiReference(<serviceVar>)`)
7. Update the solution file

## Adding a cross-service HTTP call

1. Register the bearer-forwarding handler (e.g. `AuthTokenForwardingHandler`) as transient in the calling service
2. Configure a named `IHttpClientFactory` client with `BaseAddress = new Uri("https+http://<target-service-name>")`
3. Add the handler: `.AddHttpMessageHandler<AuthTokenForwardingHandler>()`
4. Inject `IHttpClientFactory` (or a typed client) into the calling handler

## Adding a secret

1. `var <name> = builder.AddParameter("<name>", secret: true);` near the top of `AppHost.cs`
2. Pass via `.WithEnvironment("<DotnetConfig__Path>", <name>)`
3. Bind to a strongly-typed options class via the standard options helper

## Adding a Postgres enum

Register at all three sites listed in `rules/ef-core-persistence` "Postgres Specifics" — they MUST stay in sync. Then `dotnet ef migrations add <Name>` from `<Service>.Api`.

## Before finishing

- New service appears under `dotnet run` against the AppHost; `/health` is green
- Gateway routes the prefix correctly (`/<area>` → `<service>-api`)
- OpenAPI explorer lists the new API
- Database resource name in `AppHost.cs` matches the string in `AddPostgresDbContext<>("...")`
