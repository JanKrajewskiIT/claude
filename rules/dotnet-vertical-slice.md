---
paths:
  - '**/*.cs'
---

# .NET Vertical Slice Architecture

For .NET backend services with vertical-slice architecture, custom CQRS primitives (no MediatR/Wolverine), Minimal API endpoints, FluentValidation, EF Core.

## Slice structure

- One folder per use case: `Features/<Area>/<Action>/`
- `<Area>` = plural noun (`Offers`, `Profile`); `<Action>` = PascalCase verb (`Add`, `GetList`, `UpdateState`, `OAuthCallback`)
- File roles:
  - `<Action><Subject>Command.cs` / `Query.cs` — `public sealed record` implementing project's `ICommand`/`ICommand<T>`/`IQuery<T>`
  - `<Action><Subject>Request.cs` — `public sealed record`, ONLY when route/header data must merge into a `Command` or wire contract must stay decoupled from the internal one
  - `<Action><Subject>Response.cs` / `<Subject>Response.cs` — `public sealed record`
  - `<Action><Subject>Validator.cs` — `public sealed class : AbstractValidator<TCommand>`
  - `<Action><Subject>Handler.cs` — `public sealed class`, primary-constructor DI, single `ExecuteAsync(request, ct = default)`
  - `<Action><Subject>Endpoint.cs` — `public static class` with one `Map<Action><Subject>(this IEndpointRouteBuilder app)` extension
- Slice family helpers → `Features/<Area>/Shared/`
- Endpoints register in per-service `Features/FeaturesExtensions.MapFeatures(app)`
- Handlers/validators auto-register from assembly via the project's shared registration helper; do NOT call `AddScoped` for them manually

## CQRS primitives

- Commands/queries are `sealed record` implementing `ICommand`/`ICommand<TResponse>`/`IQuery<TResponse>`
- Handlers implement `ICommandHandler<...>`/`IQueryHandler<...>` with single `ExecuteAsync(request, CancellationToken cancellationToken = default)`
- Endpoints inject the CONCRETE handler type, not an interface
- Do not introduce `IMediator`/`ISender` indirection

## Endpoint recipe

Canonical fluent order (auth → validation → OpenAPI → cross-cutting):

```csharp
app.MapPost("/offers", async (AddOfferCommand request, AddOfferHandler handler, CancellationToken ct) =>
{
    await handler.ExecuteAsync(request, ct);
    return Results.Created();
})
.RequireAuthorization(AuthPolicies.RequireAnyRole)
.WithValidation<AddOfferCommand>()
.WithName("AddOffer")
.WithTags("Offers");
```

- Authorization uses named policy constants from `AuthPolicies` — never inline strings
- Validation via `.WithValidation<TRequest>()`; when `Command` is built by merging route + `Request`, inject `IValidator<TCommand>` and call `await validator.ValidateAndThrowAsync(command, ct)` manually
- `.WithName(...)` PascalCase, matches OpenAPI `operationId`
- `.WithTags("<Area>")` matches the slice area folder
- Use `Results.Created()` / `Results.Ok(result)` / `Results.NoContent()`; do not mix with `TypedResults.*`
- Avoid `MapGroup` route prefixes unless the codebase already uses them

## Handler shape

- Primary-constructor injection
- Accept and pass `CancellationToken`
- Query handlers project directly to response models with `AsNoTracking()`
- Write handlers use the feature `DbContext` directly; no repository indirection
- Resolve current user via `ICurrentUserService`; throw `InvalidOperationException`/`UnauthorizedAccessException` when identity is missing

## Validation & length constants

- Validators reuse shared constants (e.g. `DataTypeConsts.NameLength`) so DB column constraints and validator rules stay aligned
- The same constants MUST appear in `IEntityTypeConfiguration<T>.HasMaxLength(...)`

## File naming

- Domain types end with `Entity`; configurations with `Configuration`; handlers with `Handler`; endpoints with `Endpoint`; validators with `Validator`
- Mismatches break grep-ability

## Code style

- No comments inside slice handlers/endpoints/commands — slice code is self-documenting

## Boundaries

- Cross-service mechanics → shared infrastructure libraries
- Feature-specific mapping/filtering/ordering stays inside the owning slice
