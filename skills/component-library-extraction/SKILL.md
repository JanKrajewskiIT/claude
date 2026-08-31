---
name: component-library-extraction
description: Evaluate, extract, or review reusable UI components and interaction patterns moved from a product application into a shared component library. Use when separating domain behavior from reusable presentation, designing a neutral component API, or recomposing the source feature on a new library primitive.
---

# Component Library Extraction

## Goal

- Extract a reusable UI contract without moving product-specific behavior into the library.
- Leave the source feature simpler after adopting the extracted component.

## Workflow

1. Identify the repeated pattern.
   - Describe the interaction, layout, or state coordination without product vocabulary.
   - Find at least one plausible use outside the source feature.
2. Classify responsibilities.
   - Keep queries, mutations, routing, authorization, analytics, and domain validation in the application.
   - Consider visual primitives, interaction mechanics, accessibility behavior, and generic workflow shells for extraction.
3. Define the boundary.
   - Replace domain models with semantic values, slots, callbacks, and state accessors.
   - Keep copy in the application unless it is intrinsic to the reusable interaction.
   - Avoid configuration objects that expose internal implementation details.
4. Test the proposed API on paper.
   - Express the source use case and a second realistic use case with the same contract.
   - Keep the component local if the second use requires unrelated flags or escape hatches.
5. Move the smallest reusable unit.
   - Extract behavior and structure together when separating them would weaken accessibility.
   - Preserve the library's naming, styling, export, and composition conventions.
6. Recompose the source feature.
   - Adapt product data and actions at the application boundary.
   - Remove replaced local code and obsolete styling without changing unrelated behavior.
7. Assess compatibility.
   - Treat the new export as a public API.
   - Classify later renames, removals, and semantic changes using the library's versioning policy.
8. Propose validation.
   - Check both use cases, keyboard and pointer behavior, accessible naming, styling ownership, exports, and package contents.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation | Decision |
|---|---|
| Contract uses product nouns | Generalize it or keep it in the application. |
| Component owns API or route state | Keep that ownership in an application adapter. |
| Reuse requires many unrelated switches | Keep iterating locally. |
| Accessibility depends on shared structure and behavior | Extract them as one coherent primitive. |
| Source call site becomes harder to understand | Rework the boundary or stop the extraction. |

## Constraints

- Do not extract code only to reduce file size.
- Do not publish domain DTOs through a component API.
- Do not move host authorization or persistence decisions into the library.
- Do not require consumers to override library internals with fragile selectors.
- Do not claim reuse until the contract supports a distinct realistic use case.

## Completion Criteria

- The public API uses neutral semantics.
- Product behavior remains in the application boundary.
- Two realistic use cases fit without unrelated escape hatches.
- The source feature is simpler after recomposition.
- Proposed checks cover interaction, accessibility, exports, and compatibility.