---
name: dotnet-vertical-slice
description: .NET vertical-slice workflow for endpoints, handlers, validators, and EF-backed feature work. Use when adding or refactoring backend slices in any service that follows this pattern.
---

> Type: Skill (operational playbook)

Use this playbook when adding or refactoring a vertical slice in a .NET backend service.

Normative constraints live in `dotnet-vertical-slice`, `dotnet-shared-infrastructure`, `api-contract-discipline`, `dotnet-error-handling`, `ef-core-persistence`, and `security-boundaries`.

## Standard Workflow

1. Find the existing feature slice that owns the behavior; prefer extending it before creating a parallel one
2. Add or update the local `Command`/`Query`, `Validator`, `Handler`, `Endpoint`, and request/response types in that slice
3. Keep the endpoint thin and move the use-case logic into the handler
4. Use EF Core projections directly in handlers when the behavior is slice-local
5. Pass `CancellationToken` end to end
6. Register the endpoint in the per-service `FeaturesExtensions.MapFeatures`; handlers and validators auto-register

## Query Slice Checklist

- Endpoint maps the route, authorization policy, OpenAPI name + tags, and result shape
- Handler uses `AsNoTracking()` for read-only flows
- Projection returns response contracts, not entities
- Ordering and filtering rules live in the slice that owns them

## Command Slice Checklist

- Endpoint applies validation (via the standard `.WithValidation<T>()` filter or manual `ValidateAndThrowAsync` when route+body must be merged) and returns the right status code
- Validator covers required fields, length rules (using shared length constants), and simple invariants
- Handler performs the write through the feature `DbContext`
- Audit / user-scoping fields are NEVER set manually when the project uses an audit interceptor + base entity
- Shared behavior is extracted to the shared infrastructure library only when at least two slices genuinely need the same rule

## Slice File Template

```
Features/<Area>/<Action>/
  <Action><Subject>Command.cs        // public sealed record : ICommand[<TResponse>]
  <Action><Subject>Validator.cs      // public sealed class : AbstractValidator<TCommand>
  <Action><Subject>Handler.cs        // public sealed class : ICommandHandler<TCommand[, TResponse]>
  <Action><Subject>Endpoint.cs       // public static class with Map<Action><Subject>
  <Subject>Response.cs               // public sealed record (queries / commands returning data)
  <Action><Subject>Request.cs        // optional, only when route data must be merged into Command
```

## Before Finishing

- Confirm the endpoint name + tags match the area and action
- Confirm the handler does not leak EF entities to the wire
- Confirm the validator and EF configuration use the same shared length constants
- Confirm `CancellationToken` is propagated through every async call
