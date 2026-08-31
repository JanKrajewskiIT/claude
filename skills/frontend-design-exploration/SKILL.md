---
name: frontend-design-exploration
description: Propose a fresh frontend component or interface in two stages without being anchored by existing implementations. Use when the primary outcome before implementation is a new design direction, alternative component concept, visual exploration, or UI redesign that will later be adapted to an existing design system.
---

# Frontend Design Exploration

## Goal

- Produce an original, domain-appropriate design before introducing implementation bias.
- Adapt the selected direction to the existing system only after concept approval.

## Stage 1: Independent Concept

1. Clarify the outcome.
   - Identify users, primary task, content, states, constraints, and target viewports.
   - Ask only questions that materially change the concept.
2. Inspect foundations only.
   - Read brand tokens, color tokens, typography, icons, spacing scale, breakpoints, and accessibility requirements.
   - Read product-domain context needed to understand the task.
   - Do not inspect existing components, primitives, common components, page implementations, stories, or screenshots of the current solution.
3. Create the concept.
   - Define information hierarchy, interaction model, responsive behavior, and important states.
   - Use brand foundations without copying existing composition.
   - Prefer one strong direction over several cosmetic variations.
4. Present the proposal.
   - Describe structure, behavior, visual rationale, and trade-offs concisely.
   - Use a wireframe or diagram only when it clarifies layout or state transitions.
   - Use [`references/examples.md`](references/examples.md) for a concise Stage 1 output shape.
   - Stop and ask the user to approve or redirect the concept before Stage 2.

## Stage 2: System Adaptation

1. Inspect implementation assets.
   - Read existing primitives, common components, hooks, layout patterns, and nearby implementations.
   - Identify what can be reused without weakening the approved concept.
2. Map the concept.
   - Reuse primitives whose semantics and behavior match.
   - Compose or extend primitives when the gap is structural.
   - Keep a local component when the behavior is product-specific.
3. Resolve conflicts explicitly.
   - Preserve accessibility, brand tokens, and public API conventions.
   - Report compromises where the current system cannot express the approved direction cleanly.
4. Implement only when requested.
   - Follow the repository's framework and styling conventions.
   - Do not write tests unless explicitly requested.
5. Propose validation.
   - List the exact visual, accessibility, responsive, build, lint, or test checks that would provide evidence.
   - Ask for approval before running commands unless the current request already grants it.

## Decision Rules

| Situation | Decision |
|---|---|
| User requests a fresh or original design | Begin at Stage 1 and avoid existing UI implementations. |
| User requests consistency with an existing component | Inspect that component immediately; Stage 1 isolation is unnecessary. |
| User supplies a fixed design | Treat it as the approved concept and begin at Stage 2. |
| Existing primitive weakens the approved interaction | Compose or extend it instead of silently changing the concept. |
| Brand foundation conflicts with accessibility | Preserve accessibility and report the conflict. |

## Completion Criteria

- Stage 1 uses only brand foundations and required domain context.
- Existing UI implementation does not anchor the initial proposal.
- The user selects or redirects the concept before adaptation.
- Stage 2 documents reuse decisions and material compromises.
- No validation command runs without permission required by repository policy.
