# Architecture Standards

These standards are an audit checklist for existing code. Use
`dotnet-vertical-slice` and `dotnet-command-query-handler` to design new
behavior.

## Vertical Slices

- Organize application code by capability, then by use case: `<Capability>/<UseCase>/`.
- Keep the command or query, handler, validator, and endpoint of one use case in its folder.
- Do not create technical folders such as `Handlers/`, `Validators/`, or `Dtos/` inside the application layer.
- Do not reference a type from another use-case folder; move a shared type to the capability folder or the domain.
- Keep endpoint code limited to transport mapping and dispatch.

## CQRS

- Make a command change state and return at most an identifier or a small result.
- Make a query read only: no tracking, no `SaveChanges`, no published messages.
- Project a query directly to its response type instead of loading entities and mapping in memory.
- Keep one handler per command or query.
- Do not call one handler from another; extract the shared step into a domain service or an application service.

## Anemic Domain Model

- Make entities data holders: properties, identity, and relationships only.
- Allow trivial computed properties that read only the entity's own fields.
- Put rules that apply to one use case in its handler.
- Put rules shared by several use cases in a stateless domain service or policy class in the domain layer.
- Keep domain services pure: no `DbContext`, HTTP, clock, or logger dependencies; pass required values as parameters.
- Keep validation of input shape in validators and validation of business rules in handlers or domain services.
- Do not reference application, infrastructure, or transport types from the domain layer.

## Service Boundaries

- Expose only a `*.Contracts` project or package to other modules and services.
- Keep entities, `DbContext`, and handlers internal to the owning module.
- Communicate between modules through contracts, integration events, or published APIs, never through another module's database tables.
- Version integration events by adding fields; do not rename or remove fields in place.
- Keep integration events separate from domain types even when the fields match.
- Map external payloads to internal types at the boundary that receives them.
