---
name: dotnet-code-standards
description: Bring existing .NET code in line with house standards for formatting, file organization, naming, vertical slices, CQRS, anemic domain models, and service boundaries. Use when asked to clean up, normalize, restyle, or audit C# code, set up .editorconfig or StyleCop enforcement, or split a large normalization across batches or agents.
---

# .NET Code Standards

## Goal

- Move existing .NET code to one enforced standard in reviewable, behavior-preserving passes.

## When To Use

- Normalize formatting, file layout, naming, or structure of existing C# code.
- Audit a project or slice against the house standard.
- Introduce or tighten `.editorconfig`, StyleCop, or build-time style enforcement.
- Plan a repository-wide cleanup split across batches or agents.

## Do Not Use

- Use `dotnet-vertical-slice` or `dotnet-command-query-handler` to build a new feature.
- Use `ef-core-persistence` or `ef-core-migrations` for query or schema changes.
- Use `api-contract-design` when a cleanup would change an HTTP contract.

## Workflow

1. Inspect the enforcement baseline.
   - Read `.editorconfig`, `Directory.Build.props`, `Directory.Packages.props`, `stylecop.json`, and the solution file.
   - Stop and report when style enforcement is missing; the repository owns that configuration, not this skill.
2. Select the reference slice.
   - Find the slice the user names as exemplary, or ask for one.
   - Stop if no reference slice exists and the pass is architectural; propose building one first.
3. Choose exactly one pass and one scope.
   - Use the pass order in [`references/normalization-passes.md`](references/normalization-passes.md).
   - Use one project, module, or slice as the scope.
   - Do not combine a mechanical pass with a structural or architectural pass.
4. Run the mechanical passes through tools.
   - Propose the exact `dotnet format` command for the pass and run it only with approval.
   - Do not hand-edit whitespace, braces, or using order that a formatter owns.
5. Apply the structural and architectural passes by hand.
   - Apply [`references/file-and-member-layout.md`](references/file-and-member-layout.md) for files, types, and members.
   - Apply [`references/csharp-style.md`](references/csharp-style.md) for language idioms.
   - Apply [`references/architecture.md`](references/architecture.md) for slices, CQRS, domain, and service boundaries.
   - Match the reference slice when a standard allows several shapes.
6. Preserve behavior and contracts.
   - Keep public types, serialized names, routes, message schemas, and database mappings unchanged.
   - Stop and report when a standard can be met only by a contract change.
   - Move types with namespace-sensitive behavior, such as EF configurations discovered by assembly scanning, only after confirming registration still finds them.
7. Validate the batch.
   - Propose `dotnet build <solution-or-project> -warnaserror` and the affected tests; run them only with approval.
   - Report remaining diagnostics by rule ID and file.

## Decision Rules

| Situation                                                | Decision                                                         |
| -------------------------------------------------------- | ---------------------------------------------------------------- |
| A rule has an analyzer and a code fix                    | Fix it with `dotnet format`, not by hand.                        |
| A rule has an analyzer but no code fix                   | Fix it by hand in the structural pass.                           |
| A standard conflicts with an established repository rule | Follow the repository rule and report the conflict.              |
| A violation needs a public contract change               | Leave it, record it, and ask.                                    |
| Code shape varies and the standard allows both           | Match the reference slice.                                       |
| A pass touches more than one module                      | Split it into one batch per module.                              |

## Constraints

- Do not change runtime behavior in a normalization pass.
- Do not suppress a diagnostic to pass a batch; record an accepted exception with its reason in `.editorconfig`.
- Do not add analyzer packages without dependency approval.
- Do not rewrite tests unless the user explicitly asks for test changes.

## Output

- List the pass, scope, changed files, and remaining diagnostics by rule ID.
- List deferred violations that need a contract change or a decision.
- List unrun checks with exact commands.

## Completion Criteria

- Each batch contains one pass over one scope.
- No formatter-owned rule was fixed by hand.
- Public contracts and runtime behavior are unchanged, or the required change is reported.
- The batch builds without new diagnostics, or the build is reported as unrun with its exact command.
