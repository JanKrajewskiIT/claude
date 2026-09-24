# Agent Execution

## Scope

- Apply these rules to all agent-driven work in the repository.
- Treat them as higher priority than skill advice to validate automatically.
- Interpret workflow verbs such as `run`, `test`, `validate`, or `verify` as required outcomes, not permission to execute commands or change tests.
- Treat permission as limited to the commands explicitly approved in the current request.
- Loading or selecting an on-demand skill does not expand command, test-change, process-start, or mutation permission.

## Analysis Evidence

- Derive actual behavior from source code, executable configuration, build definitions, deployment manifests, schemas, tests, and observed runtime evidence.
- Trace the relevant execution and configuration paths instead of accepting documentation claims as proof.
- Use project documentation to understand intended architecture, domain language, business context, and historical decisions, but treat it as supporting context that may be incomplete or stale.
- Report discrepancies between documentation and implementation explicitly. Do not reshape technical findings to match documentation when executable evidence disagrees.
- Update affected documentation after implementation when the change alters behavior, architecture, configuration, or a public contract. Do not use documentation updates as a substitute for analyzing the implementation.

## Tests

- Do not write, scaffold, generate, update, or delete tests unless the user explicitly requests test changes.
- Do not add test projects, runners, fixtures, snapshots, mocks, or CI test gates as a side effect.
- A new feature, component, endpoint, fix, refactor, or public API change does not imply permission to change tests.
- When existing tests are likely to require changes, report that impact without modifying them.

## Command Approval

- Do not run validation or execution commands unless the user explicitly approved them in the current request.
- Do not start applications, development servers, watchers, background jobs, containers, or other long-running processes without explicit approval in the current request.
- Ask one concise question before running commands and state each exact command, its arguments, working directory, purpose, and material side effects.
- Request new approval when the command, arguments, scope, or working directory changes materially.
- Do not infer approval from a request to edit code, fix an issue, review files, or prepare a commit.
- When a useful check is not authorized, continue with available static evidence and report the exact check as unrun.

Approval is required for:

- Tests, builds, compilation, type checks, verification scripts, linters, and formatters.
- Package installation, restore, audit, update, publish, and dependency resolution.
- Code generation, database migrations, schema updates, and data seeding.
- Application startup, development servers, containers, deployment, and infrastructure commands.
- Benchmarks, coverage, security scanners, static analysis, and automated diagnostics.
- Auto-fix commands and any command that can modify generated or source files.

## After Changes

- Summarize the implementation without running checks automatically.
- State which relevant checks remain unrun.
- Propose the smallest useful validation set with exact commands.
- Ask whether to run those commands only when validation would add useful evidence.
- Do not repeatedly ask after the user declines validation unless the scope changes.

## Exceptions

- Run a command without another question only when the current request explicitly names or clearly authorizes that command.
- Stop and request approval when an approved command prompts for additional unapproved actions.
- Never treat permission from an earlier conversation or request as current approval.
