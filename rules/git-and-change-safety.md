# Git and Change Safety

## Scope

- Inspect the current worktree before operations that can overwrite or publish changes.
- Treat unrecognized modifications as user-owned work.
- Keep edits limited to the requested behavior and its required contracts.
- Leave unrelated formatting, generated files, and metadata unchanged.

## History

- Use history or blame only when current code cannot explain an important decision.
- Do not rewrite shared history unless the user explicitly requests it and accepts the impact.
- Do not discard, reset, clean, stash, or restore user changes without explicit approval.
- Prefer reversible operations when multiple approaches satisfy the task.

## Commits

- Never create a branch, commit, tag, release, or push changes on the agent's own initiative.
- After implementation and authorized validation, ask at most once whether to perform the relevant Git operation.
- State the proposed branch name, commit message, remote, and target ref for every applicable operation.
- Require explicit approval for each operation. Approval to create a branch does not authorize a commit, and approval to commit does not authorize a push.
- Stage only files that belong to the requested change.
- Describe observable behavior and compatibility impact in commit or release text.
- Never include credentials, local environment files, or unrelated generated artifacts.

## Compatibility

- Preserve public contracts by default.
- Classify breaking changes from the consumer's perspective.
- Separate mechanical refactoring from behavior changes when practical.
- Surface migration requirements before applying an irreversible change.

## Dependencies

- Reuse platform capabilities and dependencies already owned by the repository before adding another package.
- Compare a proposed dependency's capability, maintenance, security, bundle or runtime cost, transitive dependencies, and compatibility impact with the actual requirement.
- Prefer a small, focused local implementation when the required behavior is simple, stable, testable, and substantially narrower than the proposed library.
- Do not recreate cryptography, authentication protocols, complex parsers, standards-heavy behavior, or other security-sensitive or specialized capabilities with ad hoc code.
- Do not install an external library or add it to a package manifest, project file, dependency declaration, or lockfile without explicit approval in the current request.
- Before requesting approval, explain the required capability, why platform and existing repository options are insufficient, the proposed library, and the material maintenance, security, licensing, runtime, or bundle impact.
- Present the smallest viable local approach and the best-fitting dependency when both are reasonable choices.
- Do not add a library for one trivial helper, formatting operation, collection transformation, or thin wrapper around a platform API.
