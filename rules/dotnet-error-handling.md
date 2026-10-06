# .NET Error Handling

## Scope

- Apply this rule when creating, changing, or reviewing failure handling in .NET code.
- Apply `dotnet-conventions` for general .NET structure and compatibility.

## Classification

- Distinguish expected domain, validation, authorization, conflict, dependency, cancellation, and unexpected failures.
- Reuse established exception or result types before creating local equivalents.
- Use exceptions for exceptional or boundary failures, not routine branching when the repository uses explicit results.
- Preserve caller cancellation as cancellation instead of reporting it as an application failure.
- Give consumer-distinguishable failures stable machine-readable codes; add a new exception type only when control flow or typed boundary data requires it.

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
- Align retry classification across HTTP clients, background work, messaging, and telemetry according to whether another attempt can change the outcome.
- Treat unknown failures as non-disclosing while preserving diagnostic correlation and the original cause.

## Completion Criteria

- Every expected failure has one classification and one stable transport mapping at the owning boundary.
- Caller cancellation surfaces as cancellation, not as an application failure.
- No client response or log entry discloses internals, secrets, or sensitive payloads.
- Only failures that another attempt can change are retried.
