---
paths:
  - '**/*'
---

# Git & Workflow Standards

## Branching

- Base branch: `main`
- Feature branches from `main`, single-responsibility when possible

## Commit messages

- Conventional prefixes: `feat:`, `fix:`, `refactor:`, `docs:`
- Imperative mood, describe intent (not file names)

## Versioning & public API

- Public exports from `src/index.ts` and public props are semver-governed
- `fix:` → patch; `feat:` → minor (unless explicitly breaking); breaking → major
- Public API changes include a short migration note in PR
- Prefer additive evolution; only remove/rename with explicit migration guidance

## Deprecation policy

- Mark deprecated for at least one minor cycle before removal
- Keep deprecated APIs functional with a replacement path
- Demo migrates to the replacement immediately

## Commands

Available npm scripts:

- `npm run verify` — typecheck + lint + build + test
- `npm run build`
- `npm run lint:fix`
- `npm run format`
- `npm test`

**Agents MUST NOT run these after implementing/changing code unless the user explicitly asks.** See `rules/project-core.md` "Agent Execution Policy".

## CI

- CI publishes on push to `main`
- Keep `main` green and releasable
