---
name: implementation-spec-authoring
description: Create or refine concise implementation specifications, task files, future-work backlogs, or clean-room rebuild requirements. Use when planning a feature, architecture change, project foundation, migration, deferred task, unresolved decision, or a from-scratch reimplementation derived from existing behavior.
---

# Implementation Spec Authoring

## Goal

- Produce a traceable specification another engineer or agent can implement without rediscovering scope, decisions, dependencies, or completion conditions.

## Workflow

1. Define the requested outcome, consumers, boundaries, constraints, non-goals, and acceptance evidence.
   - Stop when unresolved ambiguity could change security, data, public behavior, or compatibility.
2. Inspect implementation and executable configuration for current behavior.
   - Use documentation for intent and context and record conflicts instead of treating prose as executable truth.
   - When preparing a clean-room rebuild, treat the implementation as behavioral evidence rather than a design template.
3. Record requirements with stable identifiers and provenance.
   - Use `SOURCE` for an authoritative artifact, `USER` for a user decision, `AGENT` for a proposed interpretation, and `ASSUMPTION` for unresolved input.
4. Create one overview for outcome, scope, sources, decisions, assumptions, task index, dependency order, and shared acceptance criteria.
   - Keep each independently implementable task in a separate file.
5. Separate project setup, shared infrastructure, and architecture tasks from business capabilities when they are independently deliverable.
6. Describe each task with purpose, rationale, inputs, implementation path, affected contracts, risks, acceptance criteria, and exclusions.
   - State observable results instead of narrating anticipated edits.
   - In clean-room mode, limit the implementation path to required technologies, boundaries, dependencies, and contracts.
7. Keep requirements technology-neutral when multiple implementations are valid.
   - Name technologies and files when correctness depends on them or the repository has already selected them.
8. Include code only when exact syntax is itself a contract, such as a schema, protocol shape, migration, or configuration key.
9. Review the complete specification with [`references/review-checklist.md`](references/review-checklist.md).

## Clean-Room Rebuild Mode

- Enter this mode when the user asks to derive an exact specification from existing code and later replace that implementation from scratch.

1. Establish the rebuild boundary.
   - Confirm that the next implementation must be created from the approved specification without consulting the removed or archived implementation.
   - Identify which runtime, language, framework, libraries, protocols, deployment environment, and compatibility surfaces must remain.
2. Extract observable behavior.
   - Record user outcomes, inputs, outputs, state transitions, errors, permissions, accessibility behavior, persistence effects, integration effects, timing, concurrency, and operational constraints.
   - Record edge cases only when supported by executable evidence, an authoritative contract, or an explicit user decision.
3. Preserve contracts, not structure.
   - Include public types, schemas, routes, events, storage representations, configuration keys, and library constraints only when consumers or the environment depend on them.
   - Exclude private file layout, component hierarchy, helper names, internal abstractions, algorithms, DOM structure, selectors, and state shape unless they are observable compatibility contracts.
4. Classify legacy behavior.
   - Mark accidental behavior, workarounds, duplication, and suspected defects separately from requirements.
   - Require a user decision before preserving questionable behavior in the rebuild contract.
5. Make the specification independently implementable.
   - Define acceptance evidence that can evaluate a new implementation without comparing its source structure with the old implementation.
   - Keep implementation guidance to required technologies, integration boundaries, and essential contracts.
6. Freeze the handoff.
   - Identify the approved specification version as the sole implementation brief.
   - State that the rebuilding agent must not inspect old source, diffs, screenshots of the old solution, or implementation-specific documentation unless the user reopens that source explicitly.
7. Separate deletion from specification.
   - Do not delete, overwrite, or archive the existing implementation without explicit approval for that operation.
   - Confirm that the specification and required contracts are preserved before any approved removal.

## Task Rules

- Give each task one primary outcome and make completion independently reviewable.
- Reference requirement identifiers instead of copying source prose repeatedly.
- Mark `AGENT` decisions as proposed until accepted and preserve their provenance afterward.
- Keep assumptions visible with an owner or resolution condition.
- Link dependencies explicitly and avoid repeating overview context.
- Keep concrete deferred work in the owning project's future-work document only when it has an outcome, provenance, blocker, and reconsideration trigger.
- Do not invent dates, priorities, owners, estimates, or commitments.

## Constraints

- Do not turn a specification into a code dump, tutorial, transcript, or broad design essay.
- Do not invent business rules, acceptance criteria, architecture constraints, or provenance.
- Do not combine unrelated tasks merely to reduce file count.
- Do not present an unapproved proposal or unresolved assumption as committed work.
- Do not use future work as a completed-work archive or replacement for the authoritative backlog.
- Do not preserve a legacy implementation choice merely because it is present in source.
- Do not make the clean-room specification detailed enough to reconstruct private implementation structure.

## Completion Criteria

- The overview defines outcome, boundaries, sources, decisions, assumptions, and task sequence.
- Each task describes one implementable result with observable acceptance criteria.
- Every material requirement and decision has explicit provenance and status.
- Independently deliverable foundation and business work remain separate.
- Deferred items are concrete, traceable, and have a defined lifecycle.
- Clean-room rebuild specs preserve observable behavior and required contracts without prescribing the legacy implementation.
- Any removal of existing implementation remains separately authorized and recoverable through the repository history or an approved archive.
