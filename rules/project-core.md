---
paths:
  - '**/*'
---

# VelvetUi — Core Principles

## Scope

- Generic, app-agnostic core components: no auth, data-fetching, or business workflow in primitives
- Extracting from app to VelvetUi: prefer reusable patterns and renamed generic contracts over copying flows 1:1
- If extracted code still reads as domain-specific, generalize it or treat as a template/business-layer component
- If a component mainly binds app queries, copy, route state, or domain models onto VelvetUi primitives, keep it in the app

## What belongs in VelvetUi

- Move code in only when behavior is generic, reusable, semantically stable across more than one app flow
- Prefer extracting primitives, shared surfaces, generic workflow shells, typed helpers, infrastructure utilities
- If a consumer-app component reads without product-specific terms, it's a stronger candidate

## What stays in the consumer app

- Domain vocabulary, business validations, API wiring, auth-driven decisions, route coupling, product-specific empty states
- Thin adapters around library primitives may stay in the app when they mostly bind app copy/models/queries/mutations
- Do not move a component if its public API would need app-specific prop names

## Extraction standard

- Extract the reusable pattern, not the exact screen fragment
- Rename contracts to neutral semantics before export
- Replace app-local copy with semantic props or VelvetUi-owned generic i18n
- Keep request mapping, persistence, query invalidation in the app even when the visual shell moves
- A VelvetUi export should read clearly in another app without source-product knowledge
- Prefer composable slots, semantic props, typed callbacks over sprawling configuration objects
- If extraction needs many escape hatches or host CSS overrides, keep iterating in the app first

Operational workflow → `skills/extract-to-velvetui`.

## Code style

- Self-documenting: no comments explaining obvious behavior, no commented-out code, no `eslint-disable`
- No hardcoded secrets

## Agent Execution Policy

These rules apply to AI/agent work and OVERRIDE any "verify after every change" or "add tests for new components" advice elsewhere.

### Tests

- Do NOT write, scaffold, or modify tests unless the user explicitly asks in the current request
- Do NOT add test files, runners, fixtures, or CI test gating as a side effect
- "New reusable component" or "public API change" is NOT a trigger to write tests
- When existing tests would obviously break, mention it — do not silently update or delete them
- `rules/testing.md` is the contract for HOW to write tests IF asked; never a trigger to write them

### Build / lint / typecheck / verify

- Do NOT run `npm run build/verify/lint/typecheck`, `npm test`, `dotnet build/test`, or equivalents after code changes, unless:
  - the user explicitly asked, OR
  - the change is to build/tooling/config itself (run only what validates that config), OR
  - a previous step in the same request already failed and you are diagnosing
- Do NOT run "just to be sure"
- Do NOT auto-fix lint/format on files you did not otherwise modify
- On commit requests, follow the standard commit flow without inserting verify

### Reporting

- After finishing, summarize and stop. Do not append "I'll now run verify" unless asked
- If a verification step seems warranted (e.g. a refactor across many files), ask first with one short question instead of running it
