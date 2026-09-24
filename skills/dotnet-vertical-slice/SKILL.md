---
name: dotnet-vertical-slice
description: Create, extend, or review vertical slices in .NET applications using endpoints, use-case handlers, validation, and persistence. Use when the primary outcome is an end-to-end .NET use case organized by business capability, including its implementation boundaries and registration.
---

# .NET Vertical Slice

## Goal

- Deliver one cohesive use case with explicit contracts and minimal coupling.
- Follow the repository's existing .NET architecture and registration model.

## Workflow

1. Locate the owning capability.
   - Inspect neighboring slices, shared abstractions, and registration code.
   - Extend an existing slice when it already owns the behavior.
2. Define the boundary.
   - Specify input, output, authorization, validation, and failure behavior.
   - Keep transport contracts separate from persistence entities.
   - Record external effects, compatibility needs, rollout controls, telemetry outcomes, and explicit non-goals when the slice crosses those boundaries.
3. Choose the slice parts.
   - Add only the endpoint, request, response, handler, validator, and mapping required.
   - Use the repository's command, query, or direct-handler convention.
   - Use [`references/examples.md`](references/examples.md) to clarify responsibility boundaries when needed.
4. Implement the use case.
   - Apply `dotnet-command-query-handler` when the work centers on a discrete application handler or the repository uses explicit command and query contracts.
   - Keep transport concerns in the endpoint.
   - Keep use-case decisions in the handler.
   - Keep domain invariants in the domain model when they apply beyond one use case.
   - Propagate `CancellationToken` through asynchronous operations.
5. Implement persistence.
   - Use no-tracking queries for read-only EF Core operations.
   - Project directly to response contracts when practical.
   - Avoid adding a repository abstraction unless the codebase already requires it.
6. Wire the slice.
   - Register endpoints, handlers, validators, mappings, and policies using local patterns.
   - Avoid duplicate registration when assembly scanning is present.
7. Validate.
   - Propose the narrowest repository-native build or test for the affected project.
   - Ask before running commands unless the current request already grants permission.
   - Exercise success, validation failure, authorization failure, and expected not-found or conflict behavior.
8. Coordinate cross-cutting changes when required.
   - Apply `api-contract-design`, `ef-core-migrations`, `dotnet-http-integration`, or `dotnet-configuration` only when the slice crosses that boundary.
   - Apply `message-producer-reliability` or `message-consumer-reliability` when the slice publishes or consumes messages.
   - Resolve transaction and message-publication consistency before wiring external effects.
   - Add telemetry once at the owning business boundary and define rollout observation and recovery for material changes.

## Decision Rules

| Question | Decision |
|---|---|
| Does behavior belong to one use case? | Keep it inside the slice. |
| Is an invariant shared by multiple use cases? | Move it into the domain model. |
| Is technical integration reused by multiple slices? | Use the established infrastructure boundary. |
| Does a contract cross the HTTP boundary? | Do not expose persistence entities. |
| Does the repository use MediatR or custom dispatch? | Preserve the existing dispatch model. |

## Constraints

- Do not reorganize unrelated slices.
- Do not introduce a new architectural framework for one feature.
- Do not hide authorization or transaction boundaries in incidental helpers.
- Do not claim atomic behavior without verifying the transaction boundary.

## Completion Criteria

- The owning capability and public contract are clear.
- Endpoint, handler, domain, and persistence responsibilities do not overlap accidentally.
- Validation and failures map to intentional API behavior.
- Cancellation reaches every cancellable asynchronous boundary.
- Registration is complete and focused validation passes.
- Configuration, telemetry, compatibility, and rollout behavior are explicit when the use case crosses those boundaries.
