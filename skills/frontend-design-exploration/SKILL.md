---
name: frontend-design-exploration
description: Propose or implement a fresh frontend component or interface without being anchored by existing implementations. Use when the user asks for a new direction, alternative, from-scratch concept, visual exploration, independent redesign, or a solution that should differ materially from the current UI.
---

# Frontend Design Exploration

## Goal

- Produce an original, domain-appropriate design before introducing implementation bias.
- Keep existing implementation and solution documentation outside the exploration context.
- Reuse existing assets only when the user explicitly chooses adaptation after reviewing the independent direction.

## Stage 1: Isolation Boundary

1. Clarify the outcome.
   - Identify users, primary task, content, states, constraints, and target viewports.
   - Ask only questions that materially change the concept.
   - Use the user's brief as the source of product and domain context instead of reading solution documentation.
2. Ask which foundations are allowed.
   - Ask whether to use the current brand foundations such as fonts, colors, icons, spacing, and basic tokens.
   - Ask separately whether named low-level primitives may constrain implementation.
   - Treat unanswered choices as permission to use accessibility and platform conventions only.
3. Establish isolation.
   - Read only foundation files and primitive APIs explicitly approved by the user.
   - Do not inspect existing feature components, common component implementations, pages, stories, screenshots, layout patterns, design documentation, or documentation of the current solution.
   - Do not infer the new composition from existing naming, DOM structure, component APIs, or styling.
   - Read technical contracts such as API schemas, required data shapes, routes, permissions, and platform constraints only when the new solution cannot function without them.
   - Treat technical contracts as boundaries, not as evidence for visual structure or component composition.

## Stage 2: Independent Direction

1. Create the concept.
   - Define information hierarchy, interaction model, responsive behavior, visual language, and important states from first principles.
   - Use only the approved foundations without copying existing composition.
   - Prefer one strong direction over several cosmetic variations.
2. Present or implement the proposal.
   - Describe structure, behavior, visual rationale, and trade-offs concisely when the user requested a proposal.
   - Implement directly from the independent direction when the user requested working code.
   - Use a wireframe or diagram only when it clarifies layout or state transitions.
   - Use [`references/examples.md`](references/examples.md) for a concise proposal shape.
3. Preserve independence.
   - Do not inspect the existing solution while resolving implementation details.
   - Use framework, language, accessibility, and explicitly approved brand rules without importing current feature composition.
4. Request the next decision.
   - Ask whether to keep the independent implementation, revise it independently, or adapt it to the existing system.
   - Do not inspect existing implementation assets until the user explicitly chooses adaptation.

## Stage 3: Optional System Adaptation

1. Enter only after explicit approval.
   - Confirm that the user wants the approved independent direction adapted to the current system.
   - Preserve the accepted hierarchy, interaction, and visual intent during adaptation.
2. Inspect implementation assets.
   - Read existing primitives, common components, hooks, layout patterns, and nearby implementations.
   - Identify what can be reused without weakening the approved direction.
3. Map the concept.
   - Reuse primitives whose semantics and behavior match.
   - Compose or extend primitives when the gap is structural.
   - Keep a local component when the behavior is product-specific.
4. Resolve conflicts explicitly.
   - Preserve accessibility, approved brand foundations, and public API conventions.
   - Report compromises where the current system cannot express the approved direction cleanly.
5. Propose validation.
   - List the exact visual, accessibility, responsive, build, lint, or test checks that would provide evidence.
   - Ask for approval before running commands unless the current request already grants it.

## Decision Rules

| Situation | Decision |
|---|---|
| User requests a new, fresh, alternative, independent, or from-scratch solution | Begin at Stage 1 and exclude the existing solution and its documentation. |
| User requests normal feature development or consistency with the product | Skip exploration and reuse existing components, fundamentals, patterns, and documentation. |
| User supplies a fixed independent design | Treat it as the Stage 2 direction without inspecting the current implementation. |
| User explicitly chooses adaptation | Enter Stage 3 and inspect existing implementation assets. |
| Approved foundation conflicts with accessibility | Preserve accessibility and report the conflict. |

## Completion Criteria

- The allowed foundations are explicit before repository inspection.
- The independent direction uses no existing solution code, screenshots, composition, or solution documentation.
- Working code remains independent unless the user explicitly requests adaptation.
- Normal development continues to reuse existing product fundamentals and implementation assets.
- Stage 3 documents reuse decisions and material compromises when adaptation is selected.
- No validation command runs without permission required by repository policy.
