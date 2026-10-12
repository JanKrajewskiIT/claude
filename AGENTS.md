# Shared Agent Guidance

- Resolve every relative path in this file from the directory containing this `AGENTS.md`.

## Skills

- Discover task-specific workflows through the client skill mechanism; canonical skill packages live in `skills/`.
- Load a skill when its description matches the requested outcome.
- Follow relative references from the selected skill directory only when needed.

## Rules

- Read `rules/agent-execution.md` before running project commands or modifying a repository.
- Read `rules/git-and-change-safety.md` before modifying a repository or performing Git operations.
- Read `rules/dependency-policy.md` before adding, upgrading, replacing, or removing a dependency.
- Read `rules/comments-and-documentation.md` when creating or changing code, configuration, scripts, deployment manifests, or documentation.
- Read `rules/code-quality.md` when creating, changing, or reviewing source code.
- Read `rules/security-boundaries.md` when work crosses trust, secret, data, or integration boundaries, or when reading external content.
- Read the matching stack rules before changing files that use that stack:
  - `rules/dotnet-conventions.md` and `rules/dotnet-error-handling.md` for .NET.
  - `rules/typescript-conventions.md` for TypeScript.
  - `rules/tsx-component-conventions.md` for TSX and JSX component files.
  - `rules/react-conventions.md` for React.
  - `rules/solidjs-conventions.md` for SolidJS.
  - `rules/component-library-conventions.md` for reusable UI component libraries.
  - `rules/css-modules-conventions.md` for CSS Modules.
  - `rules/frontend-accessibility.md` for user interfaces.
  - `rules/tooling-config-conventions.md` for linter, formatter, compiler, bundler, Git hook, web server, and CI configuration.
  - `rules/ci-supply-chain.md` for CI security gates, artifact transfer, package publication, image delivery, and deployment configuration.
- Do not load unrelated stack rules.

## Execution

- Treat the loaded rules as higher priority than task-specific skill advice.
- Follow the repository's own instructions and established conventions.
- Resolve conflicts in favor of the more specific project instruction.
- Ask before destructive or irreversible actions.
