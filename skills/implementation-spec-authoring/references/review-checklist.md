# Implementation Spec Review Checklist

## Outcome And Scope

- [ ] The desired result, consumer, in-scope behavior, and exclusions are explicit.
- [ ] Security, data, compatibility, and operational constraints are recorded.
- [ ] Unresolved assumptions have owners or resolution conditions.

## Provenance

- [ ] Every material requirement has a stable identifier and source.
- [ ] User decisions, agent proposals, and assumptions remain distinguishable.
- [ ] Conflicts between sources, decisions, and executable evidence are visible.

## Tasks

- [ ] Each task has one primary outcome, explicit dependencies, and observable acceptance criteria.
- [ ] Setup and architecture work is separate when independently deliverable.
- [ ] Steps explain the path to the result without prescribing unnecessary implementation.

## Future Work

- [ ] Each item states an outcome, rationale, provenance, blocker, and reconsideration trigger.
- [ ] Unapproved proposals and undecided options are not presented as commitments.
- [ ] Selected, completed, rejected, or obsolete items leave the future-work document.

## Clarity

- [ ] Bullets are concrete and avoid repeated background prose.
- [ ] Code appears only when exact syntax is part of the contract.
- [ ] The overview indexes tasks without duplicating their bodies.

## Clean-Room Rebuild

- [ ] Observable behavior is separated from private implementation structure.
- [ ] Required technologies, libraries, protocols, and compatibility surfaces are explicit.
- [ ] Public types, schemas, routes, events, storage shapes, and configuration keys are included only when contractual.
- [ ] Private files, helpers, algorithms, component trees, DOM structure, selectors, and internal state are excluded unless externally observable.
- [ ] Suspected defects, workarounds, and accidental behavior require an explicit preservation decision.
- [ ] Acceptance evidence can evaluate a replacement without comparing source structure.
- [ ] The approved spec is sufficient for implementation without reopening old source.
- [ ] Deletion or archival of the old implementation has separate explicit approval.
