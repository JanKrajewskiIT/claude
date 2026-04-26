---
name: dotnet-nuget-package
description: Workflow for shared .NET infrastructure libraries published as NuGet packages. Use when extending shared packages or evaluating extraction into shared infra.
---

Normative constraints: `rules/dotnet-shared-infrastructure`, `rules/dotnet-csharp-style`.

## Layered package structure

Multi-package shared libraries split along dependency tiers:

- `Application` — CQRS contracts, abstractions only. Zero third-party deps.
- `Domain` — base entities, domain exceptions, domain abstractions. Zero third-party deps.
- `Infrastructure` — EF Core, Npgsql, auth, OTel, caching, validation. ALL third-party deps land here.

Reference flow: API → Infrastructure → Domain → Application. Never reversed. If `Application` or `Domain` needs a third-party type, redesign with an abstraction.

## Versioning

- All packages in the same shared library share one version; bump every `.csproj` together
- Consumers pin centrally (e.g. `Directory.Packages.props`); a bump is reviewed in one PR across all consumers in the same repo

## Backward compatibility

- Default to additive: new types, optional overloads, extension methods, constants are non-breaking
- Renames, removals, signature changes are breaking — `[Obsolete]` for one minor cycle and ship the replacement alongside
