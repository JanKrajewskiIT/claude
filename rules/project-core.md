---
paths:
  - '**/*'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# VelvetUi - Core Principles

## Scope and Responsibilities

- Generic, app-agnostic core components: no auth, data-fetching, or business workflow logic in primitives
- When extracting code from an app into VelvetUi, prefer reusable patterns and renamed generic contracts over copying business flows 1:1
- If an extracted component still reads as domain-specific, generalize it before export or treat it as a template/business-layer component
- If a component mainly binds app queries, app copy, route state, or domain models onto existing VelvetUi primitives, keep it in the app layer

## What Belongs in VelvetUi

- Move code into VelvetUi only when the behavior is generic, reusable, and semantically stable across more than one app flow
- Prefer extracting primitives, shared surfaces, generic workflow shells, typed helpers, and infrastructure utilities over feature-specific business flows
- If a consumer-app component can be described without product-specific domain terms, it is a stronger candidate for VelvetUi

## What Must Stay in the Consumer App

- Domain vocabulary, business validations, API wiring, auth-driven decisions, route coupling, and product-specific empty states stay in the consumer app
- Thin adapters around library primitives may stay in the consumer app when they mostly bind app copy, models, queries, or mutations
- Do not move a component into VelvetUi if its public API would need app-specific prop names just to remain usable

## Extraction Standard

- Extract the reusable pattern, not the exact screen fragment
- Rename contracts to neutral semantics before export
- Replace app-local copy with semantic props or VelvetUi-owned generic i18n, depending on who should own the text
- Keep request mapping, persistence, and query invalidation in the app even when the visual shell moves to VelvetUi
- A VelvetUi export should read clearly in another app without knowledge of the source product internals
- Prefer composable slots, semantic props, and typed callbacks over sprawling configuration objects
- If the extraction would require many escape hatches or host CSS overrides, keep iterating in the app first

Operational workflow lives in `skills/extract-to-velvetui`.

## Code Style and Cleanliness

- Self-documenting code: no comments explaining obvious behavior, no commented-out code, no `eslint-disable`
- No hardcoded secrets

## Agent Execution Policy

These rules apply to AI/agent work in this repository. They override any "verify after every change" or "add tests for new components" advice elsewhere in the rules and skills.

### Tests

- Do NOT write, scaffold, or modify tests unless the user explicitly asks for them in the current request
- Do NOT add test files, test runners, fixtures, or CI test gating as a side effect of an unrelated change
- "New reusable component" or "public API change" is NOT, by itself, a trigger to write tests
- When tests already exist for the file you are touching and your change would obviously break them, mention it — do not silently update or delete them
- Treat the contents of `rules/testing.md` as the contract for HOW to write tests IF the user asks; never as a trigger to write them proactively

### Build, Lint, Typecheck, Verify

- Do NOT run `npm run build`, `npm run verify`, `npm run lint`, `npm run typecheck`, `npm test`, `dotnet build`, `dotnet test`, or equivalents after implementing or changing code, unless:
  - the user explicitly asked for it in the current request, OR
  - the change is to build/tooling/config itself (then run only what is needed to validate that specific config), OR
  - a previous step in the same request already failed and you are diagnosing it
- Do NOT run these commands "just to be sure" or "to confirm nothing broke"
- Do NOT auto-fix lint/format on files you did not otherwise modify
- If the user asks to commit, follow the standard commit flow without inserting a verify step first

### Reporting

- After finishing an implementation, summarize what changed and stop. Do not append "I'll now run verify to confirm" unless asked.
- If you genuinely believe a verification step is warranted (e.g. a refactor that touches many files), ask first with a single short question instead of running it.
