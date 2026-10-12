# .NET Conventions

## Scope

- Apply this rule to C#, F#, project, and solution files in .NET repositories.
- Apply `dotnet-error-handling` for failure classification, mapping, and disclosure.

## Repository Fit

- Follow the repository's target framework, nullable policy, analyzers, formatting, and architecture.
- Extend existing registration, error, validation, and persistence patterns before adding abstractions.
- Keep changes within the owning project and capability unless a shared contract must change.
- Preserve public API compatibility by default.
- Do not name a feature folder or namespace after a shared type it uses, such as `Features.Roles` next to `Roles`; the namespace shadows the type, so alias the shared type with a `using` alias.

## C#

- Use nullable annotations to express actual contracts.
- Prefer explicit domain and transport types over loosely typed data structures.
- Keep asynchronous work asynchronous through the complete call chain.
- Propagate `CancellationToken` through cancellable operations.
- Dispose owned resources through language and framework lifetime mechanisms.

## Boundaries

- Keep transport contracts separate from persistence entities.
- Keep host configuration and dependency registration outside reusable domain logic.
- Enforce authorization and resource ownership at server boundaries.
- Map expected failures to stable application or protocol outcomes.
- Do not expose stack traces, internal exceptions, or secret configuration values.
- Treat an empty `Guid` or other default value received for an optional identifier as absent.

## Persistence

- Use read-only query behavior when no update is intended.
- Project only fields required by the consumer.
- Make transaction and concurrency boundaries explicit.
- Avoid repository or mediator abstractions unless the codebase already benefits from them.

## Changes

- Add dependencies only when platform or repository capabilities do not meet the need.
- Treat serialization, database schema, configuration, and package surfaces as compatibility contracts.
- Avoid broad solution restructuring for one feature.
- Carry a new contract field through every layer that owns it: request, command, handler, validator, response, persistence configuration, and migration; register provider-specific types in every runtime and design-time context.
- Generate a migration only for a persisted column or type change; a response-only field or a field inside a JSON column needs none, which the pending-model-changes check confirms.

## Completion Criteria

- Changes follow the repository's framework, nullable, analyzer, formatting, and architecture conventions.
- Asynchronous work and cancellation flow through the complete call chain.
- Transport, persistence, host configuration, and domain logic remain at their owning boundaries.
- Public API, serialization, schema, configuration, and package compatibility are preserved, or the break is reported.
- Every new contract field reaches each owning layer, and every new persisted change has a reviewed migration.
