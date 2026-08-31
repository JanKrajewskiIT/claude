# Rules Library

Provider-neutral source text for behavior that should remain active throughout a
repository or user session.

Rules are not part of the Agent Skills specification. Install them using the
instruction mechanism supported by the target client.

## Catalog

| Rule | Purpose |
|---|---|
| [`agent-execution`](agent-execution.md) | Require explicit approval for tests and project commands |
| [`css-modules-conventions`](css-modules-conventions.md) | Keep modular styles token-based, local, and structurally safe |
| [`dotnet-conventions`](dotnet-conventions.md) | Keep .NET changes consistent, bounded, and contract-aware |
| [`dotnet-error-handling`](dotnet-error-handling.md) | Classify, map, and disclose .NET failures consistently |
| [`frontend-accessibility`](frontend-accessibility.md) | Apply semantic, keyboard, focus, and visual accessibility baselines |
| [`git-and-change-safety`](git-and-change-safety.md) | Protect user changes, history, and public compatibility |
| [`security-boundaries`](security-boundaries.md) | Preserve trust, secret, data, and integration boundaries |
| [`solidjs-conventions`](solidjs-conventions.md) | Apply SolidJS reactivity, state, component, and async baselines |

## Installation

| Client | Installation |
|---|---|
| Generic coding agents | Add the rule body to `AGENTS.md` or the client's always-on instruction file |
| GitHub Copilot / VS Code | Copy the rule into `.github/instructions/<rule-name>.instructions.md` and add an appropriate `applyTo` frontmatter pattern |
| Claude Code | Add the rule body to `CLAUDE.md` or the repository instruction file supported by the client |
| Clients with repository rules | Copy the file into the client's rules directory and add required metadata |

## Maintenance

- Keep the provider-neutral rule in this directory as the source of truth.
- Add client metadata only in installed copies.
- Scope stack-specific rules to matching files instead of loading them for every request.
- Preserve behavior when adapting wording to a client format.
- Replace installed copies from this repository instead of editing their bodies locally.
- Do not duplicate workflow guidance that belongs in a skill.
