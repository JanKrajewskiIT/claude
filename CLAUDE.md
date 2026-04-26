# VelvetUi

Primary source project: SolidJS UI component library `@jankrajewskiit/ui` (VelvetUi). TypeScript, CSS Modules, Vite.
These instructions should support VelvetUi itself and multiple consumer applications built on top of it.
Peers: `solid-js >=1.9`, `@solidjs/router >=0.15`.

## Structure

`src/components/{category}/` (9 categories, 58+ components), `src/hooks/`, `src/models/Props.ts`, `src/theme/`, `src/utils/`, `src/i18n/`, `src/index.ts`, `config/`, `demo/`

## Instructions

This file is the entrypoint for local agent instructions in this workspace.

Normative constraints live in `rules/`.
Operational playbooks live in `skills/`.

Core VelvetUi playbooks:

- `/solidjs-component`
- `/state-and-query-playbook` (also covers consumer-app feature workflow)
- `/dom-hygiene-playbook`
- `/overlay-patterns`
- `/tooling`
- `/extract-to-velvetui`
- `/dropdown-keyboard-model`
- `/autosave-store`
- `/wizard-form`

Backend / infrastructure playbooks (any .NET + Aspire consumer):

- `/dotnet-vertical-slice`
- `/aspire-composition`

Project commands, workflow, and code-style constraints belong in `rules/`. Cross-cutting frontend rules: `project-core`, `git-standards`, `solidjs-tsx`, `reactivity-performance`, `state-and-data-flow`, `css-modules`, `dom-hygiene`, `component-file-layout`, `compound-components`, `dom-refs`, `aria-wiring`, `runtime-config-singleton`, `persisted-keys`, `page-and-providers`, `testing`, `i18n`, `demo-app`, `velvet-consumer-frontend`, `frontend-async-ux`. Backend / infrastructure rules: `dotnet-vertical-slice`, `dotnet-shared-infrastructure`, `aspire-composition`, `api-contract-discipline`, `dotnet-error-handling`, `ef-core-persistence`, `security-boundaries`.
