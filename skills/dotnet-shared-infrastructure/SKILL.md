---
name: dotnet-shared-infrastructure
description: Design, extract, evolve, or review shared infrastructure used by multiple .NET applications or services. Use when centralizing authentication helpers, error handling, telemetry, persistence conventions, HTTP handlers, configuration registration, service defaults, or other cross-cutting mechanics into a reusable project or NuGet package.
---

# .NET Shared Infrastructure

## Goal

- Share stable cross-cutting mechanics without coupling every consumer to one application's architecture.
- Keep default bootstrap behavior minimal, observable, and compatible.

## Do Not Use

- Use `dotnet-nuget-library` for package metadata, contents, packing, versioning, and publishing.
- Keep behavior needed by only one consumer in that consumer.

## Workflow

1. Inspect consumers and existing packages.
   - Search current shared projects and packages before creating a new helper.
   - Identify duplicated behavior, consumer differences, target frameworks, and release ownership.
2. Classify the candidate.
   - Share technical mechanics used consistently by multiple consumers.
   - Keep business rules, product policies, route behavior, and service-specific configuration local.
   - Stop if reuse is only hypothetical or requires consumer-specific branches.
3. Define the contract.
   - Expose focused options, interfaces, constants, handlers, or registration extensions.
   - Keep third-party implementation details out of public contracts when practical.
   - Define defaults, overrides, failure behavior, and lifecycle ownership.
   - Treat registration, startup behavior, defaults, option names, and replacement points as public compatibility contracts.
4. Choose default or opt-in behavior.
   - Include behavior in a common bootstrap only when every consumer requires it.
   - Expose optional capabilities through explicit registration or middleware methods.
   - Avoid hidden service registration and ordering dependencies.
5. Implement the smallest shared primitive.
   - Move the stable mechanism, not an entire service implementation.
   - Preserve consumer-specific adapters at each host boundary.
   - Keep secrets and environment values supplied by the consuming host.
6. Recompose representative consumers.
   - Adopt the shared primitive in at least two realistic consumers.
   - Remove duplicated code only after behavior and configuration agree.
   - Stop if either consumer becomes harder to configure or reason about.
   - Validate from clean consumers so local build output or implicit repository state cannot hide missing package behavior.
7. Assess package compatibility.
   - Apply `dotnet-nuget-library` when the shared project is packaged or released.
   - Classify changes to registration, defaults, options, dependencies, and runtime behavior as public compatibility decisions.
8. Propose validation.
   - Check clean registration, duplicate registration, missing configuration, opt-in behavior, disposal, startup failure, and representative consumers.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation                                       | Decision                                          |
| ----------------------------------------------- | ------------------------------------------------- |
| Every consumer requires the behavior            | Consider the common bootstrap.                    |
| Only some consumers require it                  | Provide an explicit opt-in extension.             |
| Behavior contains domain vocabulary             | Keep it in the owning application.                |
| Consumers configure it differently              | Share the primitive and keep host adapters local. |
| Primitive already exists in a shared dependency | Reuse or extend the existing owner.               |

## Constraints

- Do not create shared infrastructure for one consumer.
- Do not make optional behavior an invisible bootstrap side effect.
- Do not duplicate policy names, wire constants, or protocol semantics across consumers.
- Do not require a layered architecture merely to consume one primitive.
- Do not publish secrets or deployment-specific values in the package.

## Completion Criteria

- The shared contract is technical, stable, and free of product policy.
- Default and opt-in behavior are intentional.
- At least two realistic consumers use the contract without conditional branches in the shared implementation.
- Host-owned configuration and secrets remain outside the library.
- Proposed checks cover registration, lifecycle, failures, and compatibility.
