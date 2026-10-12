# Rules Library

Provider-neutral source text for behavior that should remain active throughout a
repository or user session.

Rules are not part of the Agent Skills specification. Install them using the
instruction mechanism supported by the target client.

## Catalog

| Rule                                                                | Purpose                                                                                    |
| ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| [`agent-execution`](agent-execution.md)                             | Require explicit approval for tests and project commands                                   |
| [`code-quality`](code-quality.md)                                   | Keep code single-sourced, cohesive, consistent, and free of dead paths                     |
| [`component-library-conventions`](component-library-conventions.md) | Keep reusable UI libraries consistent in exports, contracts, localization, and inventories |
| [`comments-and-documentation`](comments-and-documentation.md)       | Keep comments purposeful and project documentation canonical                               |
| [`css-modules-conventions`](css-modules-conventions.md)             | Keep modular styles token-based, local, and structurally safe                              |
| [`dependency-policy`](dependency-policy.md)                         | Justify and approve every external dependency before adding it                             |
| [`dotnet-conventions`](dotnet-conventions.md)                       | Keep .NET changes consistent, bounded, and contract-aware                                  |
| [`dotnet-error-handling`](dotnet-error-handling.md)                 | Classify, map, and disclose .NET failures consistently                                     |
| [`frontend-accessibility`](frontend-accessibility.md)               | Apply semantic, keyboard, focus, and visual accessibility baselines                        |
| [`git-and-change-safety`](git-and-change-safety.md)                 | Protect user changes, history, and public compatibility                                    |
| [`react-conventions`](react-conventions.md)                         | Apply React rendering, hooks, state, effect, and context baselines                         |
| [`security-boundaries`](security-boundaries.md)                     | Preserve trust, secret, data, and integration boundaries                                   |
| [`solidjs-conventions`](solidjs-conventions.md)                     | Apply SolidJS reactivity, state, component, and async baselines                            |
| [`tooling-config-conventions`](tooling-config-conventions.md)       | Keep tooling configuration compatible, correctly layered, consumer-resolvable, and safe    |
| [`tsx-component-conventions`](tsx-component-conventions.md)         | Keep TSX components small, modular, colocated, and structurally lean                       |
| [`typescript-conventions`](typescript-conventions.md)               | Keep TypeScript contracts narrow, validated, explicit, and modular                         |

## Installation

| Client                        | Installation                                                                                                               |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Generic coding agents         | Route the agent to matching files from `AGENTS.md`, or include critical rule bodies in its always-on instruction file      |
| GitHub Copilot / VS Code      | Copy the rule into `.github/instructions/<rule-name>.instructions.md` and add an appropriate `applyTo` frontmatter pattern |
| Claude Code                   | Copy the rule into `.claude/rules/<rule-name>.md` and add an appropriate `paths` frontmatter list                          |
| Cursor                        | Copy the rule into `.cursor/rules/<rule-name>.mdc` and configure `description`, `globs`, and `alwaysApply`                 |
| Clients with repository rules | Copy the file into the client's rules directory and add required metadata                                                  |

The consumer installer deletes and recreates each client's complete rules or
instructions directory from this canonical source. It derives each adapter's
metadata from [`rule-scopes.json`](rule-scopes.json): an empty `applyTo` list
marks an always-on rule, globs scope a stack rule, and an optional `description`
lets Cursor and Copilot apply the rule on request. A marked block in root
`AGENTS.md` routes Codex and clients without rule directories to these files.
Do not keep project-owned content in generated client directories.

## Maintenance

- Keep the provider-neutral rule in this directory as the source of truth.
- Start each rule with `## Scope` and end it with `## Completion Criteria`.
- Register every rule in `rule-scopes.json`, both catalogs, and `AGENTS.md` routing.
- Keep client metadata out of rule bodies; the installer generates it from `rule-scopes.json`.
- Scope stack-specific rules to matching files instead of loading them for every request.
- Preserve behavior when adapting wording to a client format.
- Replace installed copies from this repository instead of editing their bodies locally.
- Do not duplicate workflow guidance that belongs in a skill.
- Keep project-owned instructions outside generated client directories.
