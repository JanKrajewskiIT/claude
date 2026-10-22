# Normalization Passes

Run the passes in order. Commit each pass separately so reviewers can tell
mechanical changes from intentional ones. Add the commit hash of every purely
mechanical pass to `.git-blame-ignore-revs`.

| #   | Pass                  | Owner      | Scope per batch       | Command or reference                                               |
| --- | --------------------- | ---------- | --------------------- | ------------------------------------------------------------------ |
| 1   | Whitespace            | Tool       | Solution              | `dotnet format whitespace <solution>`                              |
| 2   | Code style            | Tool       | Solution              | `dotnet format style <solution> --severity warn`                   |
| 3   | Analyzer fixes        | Tool       | Solution              | `dotnet format analyzers <solution> --severity warn`               |
| 4   | Files and types       | Agent      | One project           | [`file-and-member-layout.md`](file-and-member-layout.md)           |
| 5   | Member layout         | Tool/Agent | One project           | [`file-and-member-layout.md`](file-and-member-layout.md)           |
| 6   | Language idioms       | Agent      | One project           | [`csharp-style.md`](csharp-style.md)                               |
| 7   | Slice structure, CQRS | Agent      | One module or slice   | [`architecture.md`](architecture.md)                               |
| 8   | Domain and boundaries | Agent      | One module            | [`architecture.md`](architecture.md)                               |

## Rules For Each Batch

- Start every batch from a clean build of the previous pass.
- Verify file moves with `git status`; a moved type must appear as a rename, not as an unrelated delete and add.
- Re-run the tool passes after an agent pass when it moved or created files.
- Stop the batch when the diff includes behavior changes; split them into a separate change.

## Delegating Batches To Agents

Give each agent:

1. The pass number and its reference file.
2. Exactly one scope path.
3. The reference slice path.
4. The completion criteria from `SKILL.md`.
5. The instruction to report deferred violations instead of changing contracts.

Run independent scopes in parallel only when they do not share files or
registration code. Review and merge each batch before starting the next pass on
the same scope.

## Locking The Standard In

- Keep `EnforceCodeStyleInBuild` and `TreatWarningsAsErrors` enabled after pass 3.
- Propose architecture tests for slice isolation, handler dependencies, and domain purity when the user asks for test changes.
- Use the same checklist in code review that the passes used.
