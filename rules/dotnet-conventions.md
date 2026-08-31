# .NET Conventions

## Repository Fit

- Follow the repository's target framework, nullable policy, analyzers, formatting, and architecture.
- Extend existing registration, error, validation, and persistence patterns before adding abstractions.
- Keep changes within the owning project and capability unless a shared contract must change.
- Preserve public API compatibility by default.

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

## Persistence

- Use read-only query behavior when no update is intended.
- Project only fields required by the consumer.
- Make transaction and concurrency boundaries explicit.
- Avoid repository or mediator abstractions unless the codebase already benefits from them.

## Changes

- Add dependencies only when platform or repository capabilities do not meet the need.
- Treat serialization, database schema, configuration, and package surfaces as compatibility contracts.
- Avoid broad solution restructuring for one feature.