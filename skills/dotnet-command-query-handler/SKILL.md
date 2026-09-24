---
name: dotnet-command-query-handler
description: Implement or review application command and query handlers in .NET. Use when adding a focused use-case handler, separating reads from writes, defining application inputs and results, setting transaction boundaries, or wiring handlers behind HTTP, messaging, or scheduled adapters.
---

# .NET Command And Query Handler

## Goal

- Deliver one cohesive application use case with explicit input, dependencies, transaction scope, result, and failure behavior.

## Workflow

1. Inspect application architecture, namespace and visibility conventions, handler abstractions, dependency registration, transaction utilities, domain model, and nearby tests.
   - Preserve the repository's dispatch approach and do not introduce CQRS ceremony without a concrete benefit.
2. Confirm use-case contract, invariants, consistency, result, known failures, and calling adapters.
   - Stop when these inputs are missing or conflict.
3. Classify state-changing or side-effecting work as a command and read-only work as a query.
   - Split mixed work only when required consistency remains intact.
4. Define one purpose-built application input and result without HTTP, broker, database-provider, or presentation types.
5. Implement through the repository's handler contract or established direct-use-case pattern.
   - Give types and members the narrowest visibility allowed by callers, dependency injection, serialization, reflection, and test architecture.
6. Introduce services, mappers, and interfaces only when they own a boundary, policy, reusable transformation, or meaningful substitution point.
7. Keep transport and persistence mapping in adapters while the handler coordinates domain behavior, repositories, external services, and outcomes.
8. Set the smallest transaction boundary preserving invariants.
   - Keep remote calls outside database transactions unless an explicit consistency contract accepts the timeout and lock cost.
9. Define concurrency, retry, idempotency, cancellation, and publication behavior.
   - Stop when duplicate effects, transaction ownership, or atomicity is ambiguous.
10. Propose unit evidence for orchestration and integration evidence for transactions, persistence, serialization, dependency injection, or framework wiring.

## Decision Rules

| Situation | Decision |
|---|---|
| Reads and writes have distinct models or consistency needs | Use separate command and query paths. |
| Separation only duplicates types and delegation | Keep one cohesive use-case path. |
| Mapping needs dependencies or substantial reusable policy | Use a focused mapper. |
| A service only forwards one call | Keep behavior in the handler or owning domain type. |
| Write must publish reliably | Use the repository's explicit outbox or consistency mechanism. |

## Constraints

- Do not add command and query abstractions merely to rename service methods.
- Do not let handlers depend on endpoint DTOs, broker envelopes, or tracked entities unless they are the established application contract.
- Do not hide unrelated use cases behind one generic handler.
- Do not widen production visibility solely to simplify tests.
- Do not open a transaction around slow remote work without an accepted consistency reason.
- Do not design HTTP contracts or persistence schemas in this skill.

## Completion Criteria

- The handler represents one named use case with explicit input, output, and failures.
- Command or query classification matches side effects and consistency needs.
- Each additional service or mapper has a concrete responsibility.
- Framework and transport concerns remain at their owning boundaries.
- Transaction, concurrency, cancellation, idempotency, and publication behavior are intentional.
- Proposed evidence covers orchestration and relevant runtime boundaries.

