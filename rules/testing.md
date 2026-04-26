---
paths:
  - 'src/**/*.test.tsx'
  - 'src/**/*.test.ts'
  - 'src/**/*.spec.tsx'
  - 'src/**/*.spec.ts'
---

# Testing

Projects in this workspace currently ship without automated test suites. This applies to BOTH the frontend (SolidJS / VelvetUi / consumer apps) AND the backend (.NET services, Aspire-composed solutions).

**Agents MUST NOT write tests, scaffold test infrastructure, or add test files — frontend or backend — unless the user explicitly requests it in the current request.** See `rules/project-core.md` "Agent Execution Policy".

This rule file is the contract for HOW to write tests IF the user asks. It is never a trigger to write them.

## Stack (when asked)

- Frontend: Vitest + `@solidjs/testing-library` + user-event; co-locate as `<Name>.test.tsx`
- Backend (.NET): xUnit + `Microsoft.AspNetCore.Mvc.Testing` for endpoint slice tests; one `*.Tests.csproj` per service

Adding test infrastructure (runner config, CI gating, coverage tooling) MUST be proposed explicitly, never as a side effect.
