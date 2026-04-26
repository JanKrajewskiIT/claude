---
paths:
  - '**/*.cs'
---

> Type: Rule (normative constraints)

# .NET Vertical Slice Architecture

For .NET backend services that follow a vertical-slice architecture with custom CQRS primitives (no MediatR/Wolverine), Minimal API endpoints, FluentValidation, and EF Core.

## Slice Structure

- One slice folder per use case: `Features/<Area>/<Action>/`
- `<Area>` is a plural noun (`Offers`, `Profile`); `<Action>` is a PascalCase verb (`Add`, `GetList`, `UpdateState`, `OAuthCallback`)
- Slice file roles and naming:
  - `<Action><Subject>Command.cs` / `<Action><Subject>Query.cs` — `public sealed record` implementing the project's command/query contract (e.g. `ICommand` / `ICommand<T>` / `IQuery<T>`)
  - `<Action><Subject>Request.cs` — `public sealed record`, ONLY when route/header data must be merged into a `Command`, or when the wire contract must stay decoupled from the internal one
  - `<Action><Subject>Response.cs` / `<Subject>Response.cs` — `public sealed record`
  - `<Action><Subject>Validator.cs` — `public sealed class : AbstractValidator<TCommand>`
  - `<Action><Subject>Handler.cs` — `public sealed class` with primary-constructor DI; single `ExecuteAsync(request, ct = default)` method
  - `<Action><Subject>Endpoint.cs` — `public static class` with one `Map<Action><Subject>(this IEndpointRouteBuilder app)` extension
- Slice family helpers live in `Features/<Area>/Shared/`
- Endpoints register in a per-service `Features/FeaturesExtensions.MapFeatures(app)`
- Handlers and validators auto-register from the assembly via the project's shared registration helper; do NOT call `AddScoped` for them manually

## CQRS Primitives

- Commands and queries are `sealed record` types implementing the project's `ICommand` / `ICommand<TResponse>` / `IQuery<TResponse>` interfaces
- Handlers implement `ICommandHandler<...>` / `IQueryHandler<...>` with a single `ExecuteAsync(request, CancellationToken cancellationToken = default)` method
- Endpoints inject the CONCRETE handler type, not an interface
- Do not introduce `IMediator` / `ISender` indirection on top of an existing direct-handler convention

## Endpoint Recipe

Canonical fluent order (auth first, validation, then OpenAPI metadata, then cross-cutting):

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

- Authorization uses named policy constants from a shared `AuthPolicies` (or equivalent) static class — never inline policy strings
- Validation via `.WithValidation<TRequest>()`; when a `Command` is built by merging route data with a `Request` body, inject `IValidator<TCommand>` and call `await validator.ValidateAndThrowAsync(command, ct)` manually
- `.WithName(...)` is PascalCase and matches the OpenAPI `operationId`
- `.WithTags("<Area>")` matches the slice area folder
- Use `Results.Created()` / `Results.Ok(result)` / `Results.NoContent()` consistently across the codebase; do not mix with `TypedResults.*` mid-codebase
- Avoid `MapGroup` route prefixes unless the codebase already uses them; every endpoint registers its own absolute path

## Handler Shape

- Primary-constructor injection
- Accept and pass `CancellationToken`
- Query handlers project directly to response models with `AsNoTracking()` for read paths
- Write handlers use the feature `DbContext` directly; no repository indirection unless the project already has a real shared need
- Resolve current user via the project's `ICurrentUserService`; throw `InvalidOperationException` / `UnauthorizedAccessException` when the user identity is missing

## Validation and Length Constants

- Validators reuse shared length/format constants (e.g. `DataTypeConsts.NameLength`) so that DB column constraints and validator rules stay aligned
- The same constants MUST appear in the matching `IEntityTypeConfiguration<T>.HasMaxLength(...)`

## File Naming Invariants

- Domain types end with `Entity`; configurations with `Configuration`; handlers with `Handler`; endpoints with `Endpoint`; validators with `Validator`
- Mismatches break grep-ability and rule discoverability

## Code Style

- Follow the project's `.editorconfig` for indentation (tabs vs spaces), line endings, and namespace style
- File-scoped namespaces, `using` outside namespace, primary constructors preferred
- No comments inside slice handlers/endpoints/commands; XML doc comments belong on shared infrastructure (base classes, framework helpers), not on slice classes

## Boundaries

- Cross-service mechanics belong in shared infrastructure libraries; never duplicate the same helper across two services
- Feature-specific mapping, filtering, and ordering rules stay inside the owning slice
