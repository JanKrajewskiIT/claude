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
| [`component-library-extraction`](skills/component-library-extraction/) | Extract reusable UI patterns without leaking product behavior |
| [`document-autosave`](skills/document-autosave/) | Preserve editable documents across timing, network, and concurrency failures |
| [`dom-hygiene-audit`](skills/dom-hygiene-audit/) | Simplify rendered markup while preserving semantics and behavior |
| [`dotnet-configuration`](skills/dotnet-configuration/) | Bind and validate typed .NET application configuration |
| [`dotnet-http-integration`](skills/dotnet-http-integration/) | Build bounded, resilient, and secure outbound .NET HTTP integrations |
| [`dotnet-nuget-library`](skills/dotnet-nuget-library/) | Design, pack, and evolve reusable .NET NuGet libraries |
| [`dotnet-shared-infrastructure`](skills/dotnet-shared-infrastructure/) | Share stable .NET mechanics without coupling consumer architectures |
| [`dotnet-vertical-slice`](skills/dotnet-vertical-slice/) | Implement cohesive .NET features by business capability |
| [`ef-core-migrations`](skills/ef-core-migrations/) | Evolve EF Core schemas with explicit data and deployment safety |
| [`ef-core-persistence`](skills/ef-core-persistence/) | Build bounded EF Core read and write paths |
| [`frontend-design-exploration`](skills/frontend-design-exploration/) | Explore a fresh UI direction before adapting it to existing components |
| [`frontend-form-state`](skills/frontend-form-state/) | Coordinate accessible field state, validation, submission, and recovery |
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
| [`css-modules-conventions`](rules/css-modules-conventions.md) | Keep modular styles token-based, local, and structurally safe |
| [`dotnet-conventions`](rules/dotnet-conventions.md) | Keep .NET changes consistent, bounded, and contract-aware |
| [`dotnet-error-handling`](rules/dotnet-error-handling.md) | Classify, map, and disclose .NET failures consistently |
| [`frontend-accessibility`](rules/frontend-accessibility.md) | Apply semantic, keyboard, focus, and visual accessibility baselines |
| [`git-and-change-safety`](rules/git-and-change-safety.md) | Protect user changes, history, and public compatibility |
| [`security-boundaries`](rules/security-boundaries.md) | Preserve trust, secret, data, and integration boundaries |
| [`solidjs-conventions`](rules/solidjs-conventions.md) | Apply SolidJS reactivity, state, component, and async baselines |

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
also deletes and recreates `.claude/skills/`, `.claude/rules/`, `.cursor/rules/`,
`.github/skills/`, and `.github/instructions/` from the canonical content in
`.agents/`, then replaces root `AGENTS.md` and `CLAUDE.md`. Do not keep
project-owned content in any of these generated locations.

| Client | Instructions and rules | Skills after local installation |
|---|---|---|
| Codex | Root `AGENTS.md` routes to canonical rules; generated `.codex/config.toml` enables a workspace sandbox with approval on request | Native `.agents/skills/` |
| GitHub Copilot / VS Code | Root `AGENTS.md`, generated `.github/instructions/`, and conservative terminal rules in `.vscode/settings.json` | Native `.agents/skills/` and generated `.github/skills/` |
| Claude Code | Generated `.claude/settings.json`, `.claude/rules/`, and `CLAUDE.md` importing root `AGENTS.md` | Generated `.claude/skills/` |
| Cursor | Generated `.cursor/rules/`, CLI permissions in `.cursor/cli.json`, Auto-review guidance in `.cursor/permissions.json`, and root `AGENTS.md` | Native `.agents/skills/` |

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

This produces portable and native discovery paths while keeping `.agents/` as the
only submodule. The generated root `CLAUDE.md` imports the combined `AGENTS.md`, so
Claude receives both shared and project-specific guidance. See the
[`rules` installation guide](rules/README.md) for adapter details and manual setup.

## Validation

Run the dependency-free repository validator with PowerShell 5.1 or later:

```powershell
.\scripts\validate.ps1
```

The official Agent Skills validator can also validate an individual package:

```shell
skills-ref validate ./skills/skill-creator
```
