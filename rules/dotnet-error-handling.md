---
paths:
  - '**/*.cs'
---

# .NET Error Handling

## Canonical domain exceptions

When the shared infrastructure ships named domain exceptions, use them — do not invent local equivalents:

- `DataInconsistencyException` (or project equivalent) — business-rule violations, invalid state transitions → HTTP 409
- `ValidationException` (FluentValidation) → HTTP 422
- `UnauthorizedAccessException` — authenticated caller not allowed to act → HTTP 403
- `InvalidOperationException` — ambient identity/configuration failures (missing current user) → HTTP 500

Expected business failures use one of these (or a new shared type), never raw `Exception`. New business-failure shapes go in the shared library, not in a slice.

## Wiring

The shared library's global + validation exception handlers are auto-registered by the standard service-defaults helper. Do not register custom exception middleware unless intentionally replacing one. Stack traces are emitted only in `Development`.

## LLM / AI response parsing

When the shared infrastructure provides an AI-response helper (e.g. `AiResponseHelper.CleanJsonResponse`, `AiResponseHelper.DeserializeResponse<T>`), use it for any LLM JSON. It strips ` ```json ` fences and deserializes safely; failures translate to HTTP 409. No ad-hoc fence-stripping or `JsonSerializer.Deserialize` on LLM output.

## Client-facing errors

- Never return raw exception messages, stack traces, or infra details to clients
- Validation errors preserve field-level info via `ValidationProblemDetails`
