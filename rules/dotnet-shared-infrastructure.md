---
paths:
  - '**/*.cs'
  - '**/*.csproj'
  - '**/Directory.Packages.props'
---

> Type: Rule (normative constraints)

# .NET Shared Infrastructure Library

Many projects in this style ship a dedicated shared-infrastructure library (an internal NuGet, a sibling project, or a workspace package — commonly named `Extensions.*`, `<Org>.Common.*`, or `<Org>.Infrastructure.*`) that owns cross-cutting concerns: CQRS primitives, base DbContext, auth helpers, error handlers, validation filter, OpenAPI wiring, telemetry, rate limiting, and HTTP message handlers.

When such a library exists in the codebase, follow these rules.

## Discovery and Use

- Before writing any cross-cutting helper (auth policy, exception handler, value converter, query extension, options binder, message handler), grep the shared library for an existing primitive
- Read the library's XML docs / README before reaching for a third-party equivalent
- The shared library is the source of truth for: handler-registration helper, base `DbContext`, base entities (`BaseEntity`, `AuditEntity` or equivalent), audit interceptor, current-user service, auth policies, error handlers, validation filter, length/format constants, encryption converters, SSRF validators, service-to-service HTTP handlers, structured logging, metrics, OpenAPI defaults, rate-limit policies

## Discipline

- Cross-service mechanics belong in the shared library; do NOT duplicate the same helper across two service projects
- When the right primitive is missing, add it to the shared library and bump its version, not to a one-off local helper
- Service code consumes named constants and policies from the shared library — never re-declares the same string/policy/role name locally
- Configuration sections, options classes, and binding paths owned by the shared library MUST stay consistent across services

## Versioning

- Pin the shared library version centrally (e.g. `Directory.Packages.props` for .NET) so all services use the same version
- Bumping the shared library version is a deliberate change; review every consumer for the bump in the same PR
