---
paths:
  - '**/AppHost.cs'
  - '**/Program.cs'
  - '**/appsettings*.json'
---

# Aspire Composition

For .NET solutions composed with .NET Aspire (`*.AppHost`).

## Resource names

- Lowercase + hyphenated: `<service>-api`, `<app>-web`, `gateway`, `keycloak`
- Database resource names are short lowercase nouns matching the service domain
- The string in `AddDatabase("<name>")` MUST equal the string in `AddPostgresDbContext<T>("<name>")` in the service `Program.cs`
- Service-to-service URLs use `https+http://<resource-name>` — never hardcoded host:port

## Per-service composition

Every service in AppHost MUST have:

- `.WithEnvironment("<EnvVar>", <param>)` for each cross-cutting config (auth authority, encryption keys, third-party credentials)
- `.WithHttpHealthCheck("/health")`
- `.WithReference(<db>)` then `.WaitFor(<db>)` for owned databases
- `.WithReference(<otherService>)` for cross-service refs — never env-var URLs

## Secrets

- Bind via `AddParameter(name, secret: true)`
- Pass via `.WithEnvironment("Section__Key", parameter)`
- Bind to a strongly-typed options class via the standard options helper

## Program.cs (services)

- Use the project's shared bootstrap (e.g. `RunModuleAsync(args, configureServices, configureApp, beforeRun)`) — do NOT roll your own `WebApplication.CreateBuilder`
- Run migrations in `beforeRun`, never lazily at first request
- Register endpoints in `configureApp` via the per-service `FeaturesExtensions.MapFeatures(app)`

## appsettings drift

- `appsettings.json` files MUST stay structurally identical except for service-specific sections
- Environment overrides carry only diffs; do NOT duplicate base values
- Dev-only relaxations (e.g. `RequireHttpsMetadata: false`) live only in `appsettings.Development.json`

## Gateway and OpenAPI

- Gateway routes (e.g. YARP) follow `<area>` → `<area>-api` prefix mapping
- OpenAPI explorers get one `WithApiReference(<service>)` per service
