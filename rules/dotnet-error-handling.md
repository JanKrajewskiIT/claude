---
paths:
  - '**/*'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# .NET Error Handling

## Status Code Semantics

- Use `400` for malformed requests and contract-shape problems
- Use `401` when authentication is required and missing or invalid
- Use `403` when the caller is authenticated but not allowed to perform the action
- Use `404` when the requested resource does not exist or is not visible to that caller
- Use `409` for domain conflicts such as duplicate or invalid state transitions
- Use `422` for validation failures when the request shape is valid but business validation fails
- Use `500` only for unexpected server failures

## Error Shape

- Return a consistent error payload shape for API consumers
- Validation errors should preserve field-level information when available
- Do not return raw exception messages, stack traces, or infrastructure details to clients
- User-facing messages should be safe, short, and not reveal internals

## Exception Discipline

- Do not throw broad `Exception` types for expected business outcomes
- Expected business failures should be modeled and mapped intentionally at the slice or API boundary
- Unexpected exceptions should be logged with context and translated into a safe server error response

## Shared Infrastructure Wiring

When the project ships a shared infrastructure library (see `dotnet-shared-infrastructure`):

- The library's global exception handler and validation exception handler are auto-registered by the project's standard service-defaults helper; do not register custom exception middleware unless replacing one of them intentionally
- Validation failures translate to HTTP 422 + `ValidationProblemDetails` with field-grouped errors via the validation exception handler
- Stack traces are emitted only in `Development`; production responses stay minimal
