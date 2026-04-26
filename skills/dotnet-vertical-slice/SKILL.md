---
name: dotnet-vertical-slice
description: .NET vertical-slice workflow for endpoints, handlers, validators, and EF-backed feature work. Use when adding or refactoring backend slices in any service that follows this pattern.
---

Normative constraints: `dotnet-vertical-slice`, `dotnet-shared-infrastructure`, `api-contract-discipline`, `dotnet-error-handling`, `ef-core-persistence`, `security-boundaries`.

## Standard workflow

1. Find the existing feature slice that owns the behavior; prefer extending it
2. Add/update local `Command`/`Query`, `Validator`, `Handler`, `Endpoint`, request/response types in that slice
3. Keep the endpoint thin; use-case logic lives in the handler
4. Use EF Core projections directly in handlers when slice-local
5. Pass `CancellationToken` end to end
6. Register the endpoint in per-service `FeaturesExtensions.MapFeatures`; handlers/validators auto-register

## Query slice checklist

- Endpoint maps route, authorization policy, OpenAPI name + tags, result shape
- Handler uses `AsNoTracking()` for read-only flows
- Projection returns response contracts, not entities
- Ordering and filtering rules live in the owning slice

## Command slice checklist

- Endpoint applies validation (`.WithValidation<T>()` filter or manual `ValidateAndThrowAsync` when route + body must be merged) and returns the right status code
- Validator covers required fields, length rules (shared length constants), simple invariants
- Handler performs the write through the feature `DbContext`
- Audit / user-scoping fields are NEVER set manually when the project uses an audit interceptor + base entity
- Shared behavior extracted to shared infrastructure ONLY when ≥2 slices need the same rule

## Slice file template

```
Features/<Area>/<Action>/
  <Action><Subject>Command.cs        // public sealed record : ICommand[<TResponse>]
  <Action><Subject>Validator.cs      // public sealed class : AbstractValidator<TCommand>
  <Action><Subject>Handler.cs        // public sealed class : ICommandHandler<TCommand[, TResponse]>
  <Action><Subject>Endpoint.cs       // public static class with Map<Action><Subject>
  <Subject>Response.cs               // public sealed record (queries / commands returning data)
  <Action><Subject>Request.cs        // optional, only when route data must be merged into Command
```

## Before finishing

- Endpoint name + tags match the area and action
- Handler does not leak EF entities to the wire
- Validator and EF configuration use the same shared length constants
- `CancellationToken` propagated through every async call
