---
name: component-library-extraction
description: Evaluate, extract, or review reusable UI components and interaction patterns moved from a product application into a shared component library. Use when separating domain behavior from reusable presentation, designing a neutral component API, or recomposing the source feature on a new library primitive.
---

# Component Library Extraction

## Goal

- Extract a reusable UI contract for the library's declared consumer scope while keeping product-specific policies in the application.
- Leave the source feature simpler after adopting the extracted component.

## Workflow

1. Identify the repeated pattern.
   - Establish whether the library is general-purpose or explicitly scoped to applications sharing architecture and infrastructure.
   - Read the owning project's extension inventory or migration notes when present, so approved shared integrations and additions are visible alongside the reference design system.
   - Describe the interaction, layout, or state coordination without product vocabulary.
   - Find at least one plausible use outside the source feature.
2. Classify responsibilities.
   - Keep product queries, mutations, routing, server authorization, analytics, and domain validation in the application.
   - Preserve explicitly approved client infrastructure integrations in a dedicated library module instead of replacing them with generic callbacks.
   - Consider visual primitives, interaction mechanics, accessibility behavior, and generic workflow shells for extraction.
3. Define the boundary.
   - Replace domain models with semantic values, slots, callbacks, and state accessors.
   - Keep copy in the application unless it is intrinsic to the reusable interaction.
   - Avoid configuration objects that expose internal implementation details.
4. Test the proposed API on paper.
   - Express the source use case and a second realistic use case with the same contract.
   - Stop before extraction if no distinct realistic second use case exists.
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
| Component owns product-specific API or route state | Keep that ownership in an application adapter. |
| Reuse requires many unrelated switches | Keep iterating locally. |
| Accessibility depends on shared structure and behavior | Extract them as one coherent primitive. |
| Source call site becomes harder to understand | Rework the boundary or stop the extraction. |

## Collections and Saved Views

- Extend an existing collection component before introducing a parallel implementation; retain its supported field types, nested conditions, editing and composition contracts.
- Keep record identity independent of display position, and keep cell identity independent of copied column-definition objects. Optional virtualization must preserve keyboard access, selection, editing and focused nested controls.
- Separate view-state ownership, schema reconciliation, persistence, codecs and rendering. A persisted view contains settings, not records or executable callbacks.
- Version imported settings, validate nested values and bound their size and depth. Derive accepted operators from the same definitions used by the editor, then reconcile validated settings against the current schema.
- Keep external rendering engines and domain adapters outside the UI package when the application or demo owns their integration.

## Constraints

- Do not extract code only to reduce file size.
- Do not publish domain DTOs through a component API.
- Do not move server authorization, resource ownership, or product persistence policies into UI components.
- Do not require consumers to override library internals with fragile selectors.
- Do not claim reuse until the contract supports a distinct realistic use case.

## Completion Criteria

- The decision to extract or remain local is explicit and supported by two realistic use cases.
- If extraction proceeds, the public API matches the declared consumer scope and product-specific policies remain in the application boundary.
- If extraction proceeds, the source feature is simpler after recomposition.
- If extraction stops, no speculative public API or generated package surface remains.
- Proposed checks cover interaction, accessibility, exports, and compatibility.
