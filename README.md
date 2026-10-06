# Universal Agent Guidance

Portable software-engineering skills and provider-neutral agent rules.

## Source of Truth

- Treat this repository as the canonical source for every shared skill and rule.
- Install identical skill packages in client-supported project locations.
- Adapt only rule metadata required by the target client; preserve the rule body.
- Do not maintain hand-edited shared variants in individual projects or provider directories.
- Make shared changes here, validate them, and replace installed copies from this source.

## Principles

- One skill owns one clear outcome.
- Instructions are concise, explicit, and model-independent.
- `SKILL.md` contains only the core workflow and critical rules.
- Detailed guidance belongs in `references/`; templates belong in `assets/`.
- Required frontmatter is limited to `name` and `description`.
- Every change has observable completion criteria and a validation method.
- Always-on behavior belongs in `rules/`, not in task-specific skills.

## Catalog

| Skill | Purpose |
|---|---|
| [`accessible-composite-widgets`](skills/accessible-composite-widgets/) | Build menus, listboxes, and comboboxes with correct distinct interaction models |
| [`accessible-overlays`](skills/accessible-overlays/) | Build dialogs and layered surfaces with predictable focus and dismissal |
| [`api-contract-design`](skills/api-contract-design/) | Design stable HTTP contracts, errors, pagination, and write semantics |
| [`aspire-composition`](skills/aspire-composition/) | Compose resources in .NET Aspire distributed applications |
| [`aspnet-core-endpoint`](skills/aspnet-core-endpoint/) | Implement secured ASP.NET Core endpoints matching their HTTP contracts |
| [`component-library-extraction`](skills/component-library-extraction/) | Extract reusable UI patterns without leaking product behavior |
| [`database-soft-delete`](skills/database-soft-delete/) | Define deletion, visibility, restoration, retention, and purge semantics |
| [`document-autosave`](skills/document-autosave/) | Preserve editable documents across timing, network, and concurrency failures |
| [`dom-hygiene-audit`](skills/dom-hygiene-audit/) | Simplify rendered markup while preserving semantics and behavior |
| [`dotnet-command-query-handler`](skills/dotnet-command-query-handler/) | Implement cohesive .NET application commands and queries |
| [`dotnet-configuration`](skills/dotnet-configuration/) | Bind and validate typed .NET application configuration |
| [`dotnet-http-integration`](skills/dotnet-http-integration/) | Build bounded, resilient, and secure outbound .NET HTTP integrations |
| [`dotnet-nuget-library`](skills/dotnet-nuget-library/) | Design, pack, and evolve reusable .NET NuGet libraries |
| [`dotnet-shared-infrastructure`](skills/dotnet-shared-infrastructure/) | Share stable .NET mechanics without coupling consumer architectures |
| [`dotnet-vertical-slice`](skills/dotnet-vertical-slice/) | Implement cohesive .NET features by business capability |
| [`ef-core-auditing`](skills/ef-core-auditing/) | Record trusted EF Core creation and modification metadata |
| [`ef-core-migrations`](skills/ef-core-migrations/) | Evolve EF Core schemas with explicit data and deployment safety |
| [`ef-core-persistence`](skills/ef-core-persistence/) | Build bounded EF Core read and write paths |
| [`ef-core-value-conversion`](skills/ef-core-value-conversion/) | Persist non-primitive EF Core values with explicit compatible representations |
| [`frontend-design-exploration`](skills/frontend-design-exploration/) | Explore a fresh UI direction before adapting it to existing components |
| [`frontend-form-state`](skills/frontend-form-state/) | Coordinate accessible field state, validation, submission, and recovery |
| [`implementation-spec-authoring`](skills/implementation-spec-authoring/) | Write traceable implementation specifications and task plans |
| [`message-consumer-reliability`](skills/message-consumer-reliability/) | Define reliable consumer delivery, retry, replay, and idempotency semantics |
| [`message-producer-reliability`](skills/message-producer-reliability/) | Define producer consistency, delivery, ordering, and recovery semantics |
| [`mkdocs-documentation`](skills/mkdocs-documentation/) | Maintain standalone containerized MkDocs Material documentation |
| [`multi-step-form`](skills/multi-step-form/) | Coordinate accessible step navigation, validation, drafts, and submission |
| [`skill-creator`](skills/skill-creator/) | Create and improve portable Agent Skills |
| [`solidjs-component`](skills/solidjs-component/) | Build accessible components with correct SolidJS reactivity |
| [`solidjs-state-and-query`](skills/solidjs-state-and-query/) | Separate local, persisted, and server-owned state in SolidJS applications |
| [`typed-i18n`](skills/typed-i18n/) | Build type-safe locale messages, formatting, fallback, and ownership |
| [`typescript-library`](skills/typescript-library/) | Build and verify publishable TypeScript library packages |

## Rules Catalog

| Rule | Purpose |
|---|---|
| [`agent-execution`](rules/agent-execution.md) | Require explicit approval before tests and project commands |
| [`code-quality`](rules/code-quality.md) | Keep code single-sourced, cohesive, consistent, and free of dead paths |
| [`comments-and-documentation`](rules/comments-and-documentation.md) | Keep comments purposeful and project documentation canonical |
| [`css-modules-conventions`](rules/css-modules-conventions.md) | Keep modular styles token-based, local, and structurally safe |
| [`dotnet-conventions`](rules/dotnet-conventions.md) | Keep .NET changes consistent, bounded, and contract-aware |
| [`dotnet-error-handling`](rules/dotnet-error-handling.md) | Classify, map, and disclose .NET failures consistently |
| [`frontend-accessibility`](rules/frontend-accessibility.md) | Apply semantic, keyboard, focus, and visual accessibility baselines |
| [`git-and-change-safety`](rules/git-and-change-safety.md) | Protect user changes, history, and public compatibility |
| [`react-conventions`](rules/react-conventions.md) | Apply React rendering, hooks, state, effect, and context baselines |
| [`security-boundaries`](rules/security-boundaries.md) | Preserve trust, secret, data, and integration boundaries |
| [`solidjs-conventions`](rules/solidjs-conventions.md) | Apply SolidJS reactivity, state, component, and async baselines |
| [`tsx-component-conventions`](rules/tsx-component-conventions.md) | Keep TSX components small, modular, colocated, and structurally lean |
| [`typescript-conventions`](rules/typescript-conventions.md) | Keep TypeScript contracts narrow, validated, explicit, and modular |

## Installation

Copy a skill directory into a location supported by the target client:

| Client | Example project location |
|---|---|
| Agent Skills compatible client | `.agents/skills/<skill-name>/` |
| GitHub Copilot / VS Code | `.github/skills/<skill-name>/` |
| Claude Code | `.claude/skills/<skill-name>/` |
| Cursor | `.agents/skills/<skill-name>/` or `.cursor/skills/<skill-name>/` |

Keep the skill contents identical between clients. Document integration differences
outside the package or use `compatibility` only when they are actual requirements.

### Install from One Git Submodule

Add this repository once as the canonical project source:

```powershell
git submodule add <repository-url> .agents
```

Then run the helper from the consuming repository root:

```powershell
.\.agents\scripts\install-consumer.ps1
```

The helper replaces `.claude/settings.json`, `.codex/config.toml`,
`.cursor/cli.json`, `.cursor/permissions.json`, and `.vscode/settings.json`. It
also deletes and recreates the complete skill package under `.claude/skills/`,
`.codex/skills/`, `.cursor/skills/`, and `.github/skills/`, plus the native rule
adapters under `.claude/rules/`, `.cursor/rules/`, and `.github/instructions/`.
Finally, it writes self-contained instructions to root `AGENTS.md` and
`.claude/CLAUDE.md`. Do not keep project-owned content in any generated location.

| Client | Instructions and rules | Skills after local installation |
|---|---|---|
| Codex | Self-contained root `AGENTS.md`; generated `.codex/config.toml` enables a workspace sandbox with approval on request | Generated `.codex/skills/` |
| GitHub Copilot / VS Code | Self-contained root `AGENTS.md`, generated `.github/instructions/`, and conservative terminal rules in `.vscode/settings.json` | Generated `.github/skills/` |
| Claude Code | Self-contained `.claude/CLAUDE.md`, generated `.claude/settings.json`, and `.claude/rules/` | Generated `.claude/skills/` |
| Cursor | Self-contained root `AGENTS.md`, generated `.cursor/rules/`, CLI permissions in `.cursor/cli.json`, and Auto-review guidance in `.cursor/permissions.json` | Generated `.cursor/skills/` |

This matrix describes client discovery, not model behavior. A model does not
load these files by itself; the client must support and enable the corresponding
mechanism. Generated, ignored directories exist only after the installer runs and
are not present in a fresh cloud clone unless its bootstrap runs the installer.

The permission profiles reduce prompts for read-only workspace and Git inspection.
They do not enable unrestricted execution. Cursor desktop users should select
**Auto-review** once under **Settings > Agents > Approvals & Execution**; project
`permissions.json` then guides its classifier. The shared `agent-execution` rule
still requires explicit approval in the request before tests, builds, package
operations, migrations, application startup, deployment, and similar commands.

All generated files and directories are added to the consuming repository's
`.gitignore` and removed from the Git index while remaining on disk. Commit
`.gitignore`, the `.agents` submodule pointer, and any staged removals after
review. Use `-WhatIf` to preview operations.

Update and synchronize later with:

```powershell
git submodule update --remote .agents
.\.agents\scripts\install-consumer.ps1
```

This produces independent native client packages while keeping `.agents/` as the
only submodule and source of truth. Generated instructions contain the full rule
text and do not import files from `.agents/`. See the [`rules` installation
guide](rules/README.md) for adapter details and manual setup.

## Validation

Run the dependency-free repository validator with PowerShell 5.1 or later:

```powershell
.\scripts\validate.ps1
```

It verifies skill frontmatter, completion criteria, resource reachability, local
links, README catalogs, rule routing through `AGENTS.md`, and conservative client
settings.

The official Agent Skills validator can also validate an individual package:

```shell
skills-ref validate ./skills/skill-creator
```
