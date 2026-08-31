# .NET Error Handling

## Classification

- Distinguish expected domain, validation, authorization, conflict, dependency, cancellation, and unexpected failures.
- Reuse established exception or result types before creating local equivalents.
- Use exceptions for exceptional or boundary failures, not routine branching when the repository uses explicit results.
- Preserve caller cancellation as cancellation instead of reporting it as an application failure.

## Boundaries

- Map failures to transport responses in the owning API or host boundary.
- Keep domain and application code independent of HTTP status codes when practical.
- Return one stable machine-readable error shape for each transport.
- Preserve field-level validation paths and stable error codes where clients need them.

## Disclosure

- Do not return raw exception messages, stack traces, type names, SQL, paths, or infrastructure details to clients.
- Do not log secrets, tokens, personal data, or complete sensitive payloads.
- Include correlation information that supports diagnosis without exposing internals.
- Show development details only through an explicitly controlled development policy.

## Handling

- Centralize unexpected-error handling at the host boundary.
- Catch a failure only when the current layer can recover, translate, compensate, or add useful context.
- Preserve original exception context when translating technical failures.
- Do not retry validation, authorization, conflict, or other non-transient failures.
- Keep response parsing and sanitization for untrusted external systems in dedicated boundary helpers.