---
paths:
  - 'src/**/*.test.tsx'
  - 'src/**/*.test.ts'
  - 'src/**/*.spec.tsx'
  - 'src/**/*.spec.ts'
---

# Testing

Projects in this workspace currently ship without automated test suites.

**Agents MUST NOT write tests, scaffold test infrastructure, or add test files unless the user explicitly requests it.** See `rules/project-core.md` "Agent Execution Policy".

## Stack (when asked)

- Frontend: Vitest + `@solidjs/testing-library` + user-event; co-locate as `<Name>.test.tsx`
- Backend (.NET): xUnit + `Microsoft.AspNetCore.Mvc.Testing` for endpoint slice tests; one `*.Tests.csproj` per service

Adding test infrastructure (runner config, CI gating, coverage tooling) MUST be proposed explicitly, never as a side effect.
