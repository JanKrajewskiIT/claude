# Shared Agent Guidance

- Resolve every relative path in this file from the directory containing this `AGENTS.md`.

## Skills

- Discover task-specific workflows in `skills/` through the client skill mechanism.
- Load a skill when its description matches the requested outcome.
- Follow relative references from the selected skill directory only when needed.

## Rules

- Read `rules/agent-execution.md` and `rules/git-and-change-safety.md` before modifying a repository.
- Read `rules/security-boundaries.md` when work crosses trust, secret, data, or integration boundaries.
- Read the matching stack rules before changing files that use that stack:
  - `rules/dotnet-conventions.md` and `rules/dotnet-error-handling.md` for .NET.
  - `rules/solidjs-conventions.md` for SolidJS.
  - `rules/css-modules-conventions.md` for CSS Modules.
  - `rules/frontend-accessibility.md` for user interfaces.
- Treat the loaded rules as higher priority than task-specific skill advice.
- Do not load unrelated stack rules.

## Execution

- Follow the repository's own instructions and established conventions.
- Resolve conflicts in favor of the more specific project instruction.
- Ask before destructive or irreversible actions.
