---
name: tooling
description: Vite, TypeScript, ESLint, build and packaging config for VelvetUi library and demo app. Use when modifying build config, shared presets, package exports, or demo tooling.
---

Read the actual config before editing; this skill is a workflow guide, not a config dump.

## Source of truth

- `package.json` — exports, entrypoints, scripts, publish metadata
- `vite.config.*` and files in `config/` — build and shared-tooling behavior
- `tsconfig*.json` — TypeScript compiler settings
- `demo/` config files and entrypoints — demo-specific behavior

## Library build workflow

1. Locate the existing config file that already owns the behavior
2. Prefer updating shared presets over patching one-off consumers
3. Check whether the change affects library consumers, demo, or both
4. Verify exports and build output after config changes
5. `npm run verify` after meaningful tooling edits

Typical areas: build entrypoints and package exports, shared ESLint/Prettier/Vite/TypeScript/lint-staged presets, packaging and publishing metadata, new public component wiring through `src/index.ts`.

## Demo app workflow

1. Identify whether the change belongs in shared tooling or demo-only config
2. Prefer shared presets when library and demo should stay aligned
3. Keep demo tooling simple and close to how consumers use the library
4. Re-run the relevant scripts after config changes

## Verification

Tooling changes are the one case where running verify is appropriate (the change IS the build/config). Run only what validates the change:

- `npm run dev` — local demo behavior
- `npm run build` — shipped output or app bundling
- `npm run verify` — meaningful tooling changes

For any non-tooling code change, do NOT run these — see `rules/project-core.md` "Agent Execution Policy".

## Guardrails

- Treat `src/index.ts` and published exports as semver-governed API
- Prefer additive config changes over silent breaking changes
- When changing packaging behavior, leave a short note about consumer impact
