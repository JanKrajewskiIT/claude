---
name: message-consumer-reliability
description: Design, implement, review, or test reliable asynchronous message consumers. Use when defining delivery semantics, retries, poison messages, dead letters, idempotency, ordering, acknowledgement behavior, replay, or consumer rollout changes.
---

# Message Consumer Reliability

## Goal

- Deliver a consumer with explicit delivery and failure semantics, bounded retry amplification, observable terminal outcomes, and safe duplicate handling.

## Workflow

1. Inspect the message contract, producer behavior, broker configuration, consumer identity, acknowledgement mode, retry layers, concurrency, timeouts, dead-letter handling, deployment configuration, and nearby tests.
2. Define accepted schema versions, ordering key, idempotency key, durable effects, acknowledgement point, retryable failures, terminal failures, and replay expectations.
3. Map every failure to immediate retry, delayed retry, dead letter, quarantine, or intentional discard.
   - Base the decision on whether another attempt can change the outcome, not exception hierarchy alone.
4. Calculate the worst-case processing budget across batch size, handler attempts, dependency retries, backoff, and timeouts.
   - Keep it below broker lease, visibility, heartbeat, or polling limits with operational margin.
5. Place idempotency at the durable-effect boundary and make duplicate delivery safe across replicas and restarts.
6. Preserve cancellation and shutdown and surface unexpected failures to the framework so acknowledgement and retry behavior remain effective.
7. Instrument attempts separately from terminal outcomes.
   - Count each business message once as succeeded, discarded, dead-lettered, or exhausted without using unbounded metric dimensions.
8. Define rollout behavior for consumer identity, starting position, concurrency, replay, schema compatibility, and backfill.
9. Propose direct mapping tests and real-broker evidence for delivery semantics when infrastructure behavior forms part of the contract.

## Failure Decisions

| Failure                          | Default handling                                                            |
| -------------------------------- | --------------------------------------------------------------------------- |
| Malformed or unsupported payload | Terminal path with diagnostic evidence; do not block the stream repeatedly. |
| Deterministic business rejection | Intentional discard or quarantine according to the contract.                |
| Transient dependency failure     | Bounded retry with jitter or broker-native delay.                           |
| Unknown failure                  | Retry within budget, then dead letter or quarantine with alerting.          |
| Duplicate delivery               | Return the established outcome without duplicating durable effects.         |
| Cancellation or shutdown         | Propagate immediately; do not classify as business failure.                 |

## Reliability Rules

- Evaluate a processing kill switch before deserialization only when trusted envelope metadata is sufficient; otherwise define malformed-message behavior while disabled.
- Convert transport payloads to application inputs at the adapter boundary.
- Keep nested dependency, client, framework, and broker retries intentional and bounded.
- Ensure one poison message cannot create an unbounded partition, queue, or batch stall.
- Treat a consumer identity rename as a data-position change.
- Use bounded eventual assertions and surface background failures.
- Never log secrets or complete untrusted payloads merely for diagnosis.

## Completion Criteria

- Delivery, acknowledgement, retry, discard, dead-letter, replay, and idempotency semantics are explicit.
- Worst-case processing fits broker timing and dependency capacity limits.
- Duplicate and reordered deliveries preserve promised durable effects.
- Terminal outcomes are observable once per business message and have an owner.
- Proposed tests cover successful, malformed, transient, exhausted, duplicate, restart, and rollout paths as applicable.
- Deployment configuration preserves intended starting position and consumer identity.

## Constraints

- Do not claim exactly-once processing from broker configuration alone.
- Do not retry deterministic failures without a bounded operational reason.
- Do not invent retention, replay, ordering, or data-loss tolerance.
- Stop when acknowledgement ownership, replay policy, or data-loss tolerance lacks an accountable decision.
- Do not modify tests, run brokers, or access external systems without explicit authorization.
