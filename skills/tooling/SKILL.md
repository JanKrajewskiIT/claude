---
name: tooling
description: Vite, TypeScript, ESLint, build and packaging config for VelvetUi library and demo app. Use when modifying build config, shared presets, package exports, or demo tooling.
---

> Type: Skill (operational playbook)

Use this skill for any change to library build, shared config presets, package exports, demo dev-server setup, or app-level lint/type/build config.

Read the actual config before editing; this skill is a workflow guide, not a config dump.

## Source of Truth

- `package.json` for exports, entrypoints, scripts, and publish metadata
- `vite.config.*` and files in `config/` for build and shared-tooling behavior
- `tsconfig*.json` for TypeScript compiler settings
- `demo/` config files and entrypoints for demo-specific behavior

## Library Build Workflow

1. Locate the existing config file that already owns the behavior you want to change
2. Prefer updating shared presets over patching one-off consumers
3. Check whether the change affects library consumers, demo app, or both
4. Verify exports and build output after config changes
5. Run `npm run verify` after meaningful tooling edits

Typical areas: build entrypoints and package exports, shared ESLint / Prettier / Vite / TypeScript / lint-staged presets, packaging and publishing metadata, new public component wiring through `src/index.ts`.

## Demo App Workflow

1. Identify whether the change belongs in shared tooling or demo-only config
2. Prefer shared presets when the library and demo should stay aligned
3. Keep demo tooling simple and close to how consumers use the library
4. Re-run the relevant scripts after config changes

## Verification

Tooling changes are the one case where running verify is appropriate, because the change IS the build/config itself. Even here, run only what validates the specific change:

- `npm run dev` for local demo behavior
- `npm run build` when the change touches shipped output or app bundling
- `npm run verify` after meaningful tooling changes

For any non-tooling code change, do NOT run these — see `rules/project-core.md` "Agent Execution Policy".

## Guardrails

- Treat `src/index.ts` and published exports as semver-governed API
- Prefer additive config changes over silent breaking changes
- When changing packaging behavior, leave a short note about consumer impact
