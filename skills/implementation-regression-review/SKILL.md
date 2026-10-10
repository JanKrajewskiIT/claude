---
name: implementation-regression-review
description: Compare a replacement implementation against the previous one and decide what to restore, keep or drop. Use when a rewrite or large staged change replaced working code, when asked whether the old implementation had anything better, or before committing a large replacement.
---

# Implementation Regression Review

## Goal

- Identify capabilities, infrastructure and tooling lost in a replacement and decide each with the owner.

## When To Use

- Staged or branch changes delete and recreate large parts of a codebase.
- The user asks what the previous version did better.

## Do Not Use

- Verifying a port against a design reference: use `design-system-parity-audit`.
- Judging the quality of the new code in isolation: use `solidjs-library-audit`.
- Designing configuration presets or package exports found missing: use `tooling-config-preset` or `typescript-library`.
- Reviewing a single small diff.

## Workflow

1. Inspect the change.
   - Summarize staged changes by status and folder with `git diff --cached --name-status`.
   - Note build artifacts and reference copies that were staged.
2. Snapshot the previous version outside the workspace.
   - Export it with `git archive --format=zip -o <temp>/old.zip HEAD <paths>` and expand it.
   - Avoid piping `git archive` through a shell pipe on PowerShell; the stream is corrupted.
   - Delete the snapshot when finished.
3. Map old to new.
   - Build a name mapping for renames, merges and splits.
   - Treat unmapped old names as candidates for loss.
4. Find outliers.
   - Compare line counts of each mapped pair and inspect pairs where the new side is much smaller.
   - Search old files for feature words such as drag, zoom, confirm, filter, persist, then search the new side.
5. Compare infrastructure.
   - Hooks, utilities, providers, authentication, theming, toast and error handling.
   - Establish the declared consumer scope before replacing integrations: applications sharing infrastructure may intentionally depend on the same authentication package and provider.
   - Package manifest: scripts, peer dependencies, dependencies, externals and size limits.
   - Tooling configs referenced by scripts, README and docs.
6. Verify claims before reporting.
   - Read the code that supports each claim, including build tool defaults. Correct earlier claims that evidence contradicts.
7. Classify.

   | Result | Meaning |
   |---|---|
   | Old better | Restore, adapted to the new conventions. |
   | New better | Keep; say why. |
   | Equal | No action. |
   | Intentional | Keep and record the decision. |

8. Present findings ordered by impact.
   - State breaking-change, dependency and location decisions the user must make.
   - Stop for approval before dependency additions and destructive Git actions.
9. Implement approved restorations.
   - Prefer local implementations over new dependencies; follow the dependency policy for any addition.
   - Restore approved integrations against their current source contract in one owning module; preserve package-root exports when relocating components.
   - Review restored code against the loaded rules before reporting: module size, public module state, localization, property reactivity.
   - Validate with editor diagnostics and propose exact commands for the rest.
10. Write the exact change list.

## Constraints

- Treat unrecognized modifications as user work.
- Do not stage, commit or delete history without approval.
- Do not infer quality from file size alone.

## Output

- Findings table: area, old, new, verdict, action.
- Final change list with files and consumer-visible breaking changes.

## Completion Criteria

- Every unmapped old export has a verdict.
- Scripts, externals and peer dependencies match the code that exists.
- Build artifacts and reference copies in staged changes are reported.
- The change list is exact and unrun checks are named.
