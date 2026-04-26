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
