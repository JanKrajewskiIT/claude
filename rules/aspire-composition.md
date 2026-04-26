---
paths:
  - '**/AppHost.cs'
  - '**/Program.cs'
  - '**/appsettings*.json'
---

> Type: Rule (normative constraints)

# Aspire Composition

For .NET solutions composed with .NET Aspire (`*.AppHost` orchestrator project).

## Resource Names

- Lowercase + hyphenated: `<service>-api`, `<app>-web`, `gateway`, `keycloak`
- Database resource names are short lowercase nouns matching the service domain
- The string passed to Aspire `AddDatabase("<name>")` MUST equal the string passed to the corresponding `AddPostgresDbContext<T>("<name>")` (or equivalent) call in the service `Program.cs`
- Service-to-service URLs use the Aspire scheme `https+http://<resource-name>` — never hardcoded host:port

## Per-Service Composition

Every service project added to the AppHost MUST be composed with:

- `.WithEnvironment("<RequiredEnvVar>", <param>)` for every cross-cutting config the service expects (auth authority, encryption keys, third-party credentials)
- `.WithHttpHealthCheck("/health")` (the path mapped by the project's standard health-check helper)
- `.WithReference(<db>)` then `.WaitFor(<db>)` for any owned database
- Cross-service references via `.WithReference(<otherService>)`, never via env-var URLs

## Secrets and Parameters

- Secrets MUST be bound through Aspire `AddParameter(name, secret: true)`
- Pass to consuming services via `.WithEnvironment("Section__Key", parameter)`
- Bind to a strongly-typed options class in the service via the standard options helper

## Program.cs Shape (services)

- Use the project's shared bootstrap entrypoint (e.g. `RunModuleAsync(args, configureServices, configureApp, beforeRun)`) — do NOT roll your own `WebApplication.CreateBuilder`
- Run migrations in the `beforeRun` callback (or equivalent), never lazily at first request
- Register feature endpoints in `configureApp` via the per-service `FeaturesExtensions.MapFeatures(app)`

## appsettings Drift

- `appsettings.json` files across services MUST stay structurally identical except for service-specific config sections
- Environment-specific overrides (`appsettings.Development.json`) carry only what differs; do NOT duplicate base values
- Development-only relaxations (e.g. `RequireHttpsMetadata: false`) MUST be confined to `appsettings.Development.json`

## Gateway and OpenAPI Discoverability

- Reverse-proxy / gateway routes (e.g. YARP) follow `<area>` -> `<area>-api` path-prefix mapping; new services register their prefix in the gateway block of the AppHost
- OpenAPI explorers (Scalar, Swagger UI) get one `WithApiReference(<service>)` line per service
