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

- Create commits, branches, tags, or releases only when explicitly requested.
- Stage only files that belong to the requested change.
- Describe observable behavior and compatibility impact in commit or release text.
- Never include credentials, local environment files, or unrelated generated artifacts.

## Compatibility

- Preserve public contracts by default.
- Classify breaking changes from the consumer's perspective.
- Separate mechanical refactoring from behavior changes when practical.
- Surface migration requirements before applying an irreversible change.