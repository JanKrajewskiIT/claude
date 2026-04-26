---
paths:
  - 'src/**/*.test.tsx'
  - 'src/**/*.test.ts'
  - 'src/**/*.spec.tsx'
  - 'src/**/*.spec.ts'
---

> Type: Rule (normative constraints)

# Testing

VelvetUi and most consumer apps in this style currently ship without an automated test suite.

**Agents MUST NOT write tests, scaffold test infrastructure, or add test files unless the user explicitly requests it in the current task.** See `rules/project-core.md` "Agent Execution Policy" for the binding rule. This file only describes HOW tests are written WHEN the user has asked for them.

## Stack (when the user asks for tests)

- Frontend (VelvetUi, demo, consumer web apps): Vitest + `@solidjs/testing-library` + user-event; co-locate as `<Name>.test.tsx` next to the component
- Backend (.NET services): xUnit + `Microsoft.AspNetCore.Mvc.Testing` for endpoint-level slice tests; one `*.Tests.csproj` per service
- Adding test infrastructure (runner config, CI gating, coverage tooling) MUST be proposed explicitly, never as a side effect

## What to Cover

- Default render: component mounts and exposes correct role/accessible name
- State variants that change rendered output or behavior (disabled, loading, error, selected, expanded)
- Keyboard: Tab focus, Enter/Space activation, Escape dismissal, arrow navigation where applicable
- ARIA wiring: `aria-invalid`, `aria-errormessage`, `aria-describedby` on field-like components
- Callbacks fire with the correct arguments
- Backend slices: happy path, validation failure (422), authorization failure

## What Not to Test

- Internal implementation details (signal values, CSS class names)
- Visual appearance or exact pixel layout
- Third-party primitive internals already covered by the source library

## Style

- One `describe` per component; nested `describe` per state group
- Test descriptions read as plain English sentences
- Prefer user-event interactions over raw DOM events
- Keep each test focused on a single behavior
