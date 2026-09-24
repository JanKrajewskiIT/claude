---
name: implementation-spec-authoring
description: Create or refine concise implementation specifications, task files, and future-work backlogs that trace requirements to an executable delivery path. Use when planning a feature, architecture change, project foundation, migration, deferred task, or unresolved decision before implementation.
---

# Implementation Spec Authoring

## Goal

- Produce a traceable specification another engineer or agent can implement without rediscovering scope, decisions, dependencies, or completion conditions.

## Workflow

1. Define the requested outcome, consumers, boundaries, constraints, non-goals, and acceptance evidence.
   - Stop when unresolved ambiguity could change security, data, public behavior, or compatibility.
2. Inspect implementation and executable configuration for current behavior.
   - Use documentation for intent and context and record conflicts instead of treating prose as executable truth.
3. Record requirements with stable identifiers and provenance.
   - Use `SOURCE` for an authoritative artifact, `USER` for a user decision, `AGENT` for a proposed interpretation, and `ASSUMPTION` for unresolved input.
4. Create one overview for outcome, scope, sources, decisions, assumptions, task index, dependency order, and shared acceptance criteria.
   - Keep each independently implementable task in a separate file.
5. Separate project setup, shared infrastructure, and architecture tasks from business capabilities when they are independently deliverable.
6. Describe each task with purpose, rationale, inputs, implementation path, affected contracts, risks, acceptance criteria, and exclusions.
   - State observable results instead of narrating anticipated edits.
7. Keep requirements technology-neutral when multiple implementations are valid.
   - Name technologies and files when correctness depends on them or the repository has already selected them.
8. Include code only when exact syntax is itself a contract, such as a schema, protocol shape, migration, or configuration key.
9. Review the complete specification with [`references/review-checklist.md`](references/review-checklist.md).

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

## Completion Criteria

- The overview defines outcome, boundaries, sources, decisions, assumptions, and task sequence.
- Each task describes one implementable result with observable acceptance criteria.
- Every material requirement and decision has explicit provenance and status.
- Independently deliverable foundation and business work remain separate.
- Deferred items are concrete, traceable, and have a defined lifecycle.

