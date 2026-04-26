---
paths:
  - '**/*.cs'
  - '**/*.csproj'
  - '**/Directory.Packages.props'
---

# .NET Shared Infrastructure Library

Many projects ship a shared-infrastructure library (internal NuGet, sibling project, workspace package — commonly `Extensions.*`, `<Org>.Common.*`, `<Org>.Infrastructure.*`) owning cross-cutting concerns: CQRS primitives, base DbContext, auth helpers, error handlers, validation filter, OpenAPI wiring, telemetry, rate limiting, HTTP message handlers.

When such a library exists, follow these rules.

## Discovery and use

- Before writing any cross-cutting helper (auth policy, exception handler, value converter, query extension, options binder, message handler), grep the shared library for an existing primitive
- The shared library owns: handler-registration helper, base `DbContext`, base entities (`BaseEntity`, `AuditEntity`), audit interceptor, current-user service, auth policies, error handlers, validation filter, length/format constants, encryption converters, SSRF validators, service-to-service HTTP handlers, structured logging, metrics, OpenAPI defaults, rate-limit policies

## Discipline

- Cross-service mechanics → shared library; never duplicate across services
- When the right primitive is missing, add it to the shared library and bump version, not a one-off local helper
- Service code consumes named constants/policies from the shared library — never re-declares the same string/policy/role locally

## Default bootstrap

The shared bootstrap helper (`AddServiceDefaults`, `RunModuleAsync`, equivalent) is opt-out — every consumer inherits whatever it does.

- Add to default bootstrap ONLY when every consumer service genuinely needs it
- Otherwise expose as opt-in extension method (`AddX()` / `UseX()`)

Library structure, versioning, release workflow → `skills/dotnet-nuget-package`.
