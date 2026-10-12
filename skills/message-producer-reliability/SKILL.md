---
name: message-producer-reliability
description: Design, implement, review, or test reliable asynchronous message producers. Use when defining transaction boundaries, outbox behavior, delivery guarantees, retries, ordering keys, idempotency, schema compatibility, or publish-failure recovery.
---

# Message Producer Reliability

## Goal

- Deliver a producer with explicit consistency and delivery semantics, stable contracts, bounded failure behavior, meaningful ordering, and owned recovery.

## Workflow

1. Inspect the business transaction, producer API, broker configuration, serialization, destination ownership, partitioning, retry layers, acknowledgements, and consumer expectations.
2. Define triggering transition, schema, identity, key, ordering scope, duplicate tolerance, required durability, acceptable loss or delay, and provisioning ownership.
3. Choose the consistency mechanism before implementation.
   - Use a transactional outbox when database state and publication must converge reliably.
   - Use direct publication only when its failure window and recovery are explicitly acceptable.
4. Place publication at the correct boundary.
   - If publishing before commit or losing a post-commit publication violates the contract, use durable coordination rather than call ordering alone.
5. Configure acknowledgements, retries, timeouts, batching, and producer idempotence consistently with throughput, ordering, and duplicate requirements.
6. Choose a stable key for per-entity ordering and account for partition changes and hot keys.
   - Do not imply global ordering unless the topology provides it.
7. Treat field names, types, nullability, identifiers, and semantic meaning as consumer-visible compatibility contracts.
8. Instrument accepted, acknowledged, failed, and recovered publications at their actual boundaries.
   - Define recovery for stuck publication, replay, deduplication, and retention.
9. Propose serialization and failure tests plus real-broker evidence where broker acknowledgement, ordering, or retry semantics matter.

## Consistency Decisions

| Requirement                             | Preferred mechanism                                      |
| --------------------------------------- | -------------------------------------------------------- |
| State and message must eventually agree | Transactional outbox with a replayable relay.            |
| Occasional message loss is acceptable   | Direct post-commit publication with explicit monitoring. |
| Caller must know broker acceptance      | Await the configured acknowledgement and expose failure. |
| Duplicate publication is possible       | Stable event identity plus idempotent consumer effects.  |
| Per-entity order matters                | Stable entity key and compatible partition strategy.     |

## Reliability Rules

- Name actual semantics instead of claiming exactly-once from a client setting.
- Handle failures raised both before a send handle is returned and during asynchronous acknowledgement.
- Keep application and broker retries bounded and observable.
- Do not report a completed database transaction as rolled back because publication later failed.
- Keep provisioning, retention, schema governance, and access ownership explicit.

## Completion Criteria

- The consistency mechanism matches accepted loss and duplication tolerance.
- Schema, identity, key, ordering, and compatibility behavior are explicit.
- Retry, acknowledgement, timeout, and idempotence settings form one coherent delivery policy.
- Every terminal publication outcome is observable and has an owned recovery path.
- Proposed evidence covers serialization, acknowledgement, failure, duplicate, replay, and ordering behavior as applicable.
- Consumers can evolve or replay messages without undocumented producer internals.

## Constraints

- Do not define consumer processing policy; use `message-consumer-reliability`.
- Stop when loss tolerance, duplicate tolerance, or transaction ownership lacks an accountable decision.
- Do not provision brokers, publish messages, modify tests, or run validation without explicit authorization.
