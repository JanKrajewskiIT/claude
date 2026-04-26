---
paths:
  - '**/*.cs'
---

# .NET / C# Style

Cross-cutting C# defaults. Slice structure → `dotnet-vertical-slice`. Entity properties → `ef-core-persistence`.

## Class modifiers

- `sealed` by default; drop only for types designed for inheritance
- Handlers, validators, endpoints, exception handlers, entity configurations: `sealed`
- Entity configurations: `internal sealed`
- Commands, queries, requests, responses: `public sealed record`

## DI

- Primary constructors for handlers, services, infrastructure components

## Forbidden

- No MediatR, no `IMediator`/`ISender` over direct CQRS handlers
- No repository pattern wrapping `DbContext`
- No unit-of-work abstraction over `SaveChangesAsync`

## Comments & docs

- No XML doc comments (`///`), no `//` or `/* */` comments, no `#region`, no file headers, no banner comments
- No commented-out code
- Code must be self-documenting via type names, method names, and slice layout
- Cleanup-on-touch: when editing a `.cs` file, strip any existing comments/XML docs in that file
- Test policy and overall agent execution policy → `rules/project-core.md` (Agent Execution Policy). Do NOT write xUnit tests, `*.Tests.csproj`, or `WebApplicationFactory` fixtures unless the user explicitly asks
