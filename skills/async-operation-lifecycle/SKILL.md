---
name: async-operation-lifecycle
description: Design, implement, or review asynchronous operation lifecycles with timeouts, dependency events, persistence, and invalidation. Use when investigating late results, concurrent renewals, sign-out races, stale writes, single-flight assumptions, or leaked operation registrations.
---

# Async Operation Lifecycle

## Goal

- Make an asynchronous workflow preserve its state and side-effect invariants across completion, failure, timeout, invalidation, and owner disposal.

## When To Use

- Review an operation that both returns a promise and emits dependency events.
- Investigate work that continues after its caller times out or its owner disappears.
- Coordinate concurrent operations that share persisted state or a session identity.

## Do Not Use

- Use `document-autosave` for document saving and conflict recovery.
- Use `solidjs-state-and-query` for general query ownership and cache design.
- Use `message-consumer-reliability` or `message-producer-reliability` for delivery semantics.
- Use `typescript-library` for package exports, declarations, and publishing.

## Workflow

1. Establish the contract.
   - Read the owning operation, its callers, and relevant executable configuration.
   - Identify the state owner, resource identity, observable failures, and approved compatibility constraints.
   - Separate implemented behavior from documentation claims; report disagreements rather than silently choosing a new contract.
2. Trace the underlying work.
   - Locate where the dependency starts requests, stores results, emits events, and navigates.
   - Inspect the installed dependency version when correctness depends on serialization or event ordering.
   - Mark unavailable dependency evidence as an unresolved assumption.
3. Build a transition table.
   - Record success, rejection, null result, timeout, invalidation, and disposal for each entry point.
   - Include event-driven updates, persisted data, navigation, loading state, and caller-visible results.
   - Identify which operation owns each write and cleanup action.
4. Examine overlapping runs.
   - Trace two calls with reversed completion order.
   - Trace invalidation between request start and both successful and failed completion.
   - Trace a timeout followed by a late dependency event or persistence write.
   - Trace an operation that never settles and determine whether registrations remain live.
5. Choose the coordination policy.
   - If operations share a mutation, determine whether the contract requires serialization, single-flight, or latest-result ownership.
   - If work supports cancellation, propagate it through the dependency boundary.
   - Otherwise define how late side effects are prevented or reconciled without deleting newer work.
   - Stop before changing an explicit error contract, persistence owner, or public API without approval.
6. Apply a focused change when requested.
   - Keep the coordination policy in one owning collaborator when multiple entry points share it.
   - Preserve API-specific failure mapping outside shared mechanics.
   - For a review-only request, report the defective path and smallest correction without editing production code.
7. Select discriminating checks.
   - Prefer delayed fake-dependency scenarios that observe events and writes as well as returned values.
   - Check out-of-order results, post-timeout completion, invalidation, disposal, and fresh reads after invalidation.
   - Request authorization before adding tests or executing checks; report unauthorized checks as unrun.
8. Report the outcome.
   - List findings by severity with code locations, triggering sequences, observable consequences, and proposed corrections.
   - Distinguish confirmed defects, intentional contract tradeoffs, and behavior still requiring runtime evidence.

## Completion Criteria

- Every entry point has a transition table covering timeout, invalidation, and disposal.
- Dependency events and persistence writes are included in the lifecycle analysis.
- Concurrent-run ownership and dependency serialization assumptions are explicit.
- Cleanup cannot remove a newer operation's data.
- Focused checks pass or their unavailable evidence is explicitly reported.