---
name: dotnet-http-integration
description: Design, implement, or review outbound HTTP integrations in .NET applications. Use when configuring HttpClient, typed or named clients, authentication handlers, timeouts, cancellation, retries, resilience, rate limits, response mapping, SSRF protection, or telemetry for an external or service-to-service dependency.
---

# .NET HTTP Integration

## Goal

- Make outbound calls bounded, observable, secure, and aligned with the remote contract.
- Keep transport behavior outside business use cases.

## Workflow

1. Define the dependency boundary.
   - Identify ownership, base address, operations, authentication, limits, and data sensitivity.
   - Separate the remote transport contract from application-facing models.
2. Inspect repository infrastructure.
   - Reuse existing client registration, resilience, telemetry, and credential handlers.
   - Preserve the repository's typed, named, or generated client convention.
3. Configure the client.
   - Use managed `HttpClient` registration instead of creating clients per request.
   - Set addresses, headers, and handlers through configuration and dependency injection.
   - Keep secrets out of source code, logs, URLs, and exception messages.
4. Bound execution.
   - Define operation-level timeout and caller cancellation behavior.
   - Propagate `CancellationToken` through every cancellable call.
   - Bound response sizes and streaming behavior where payload size is uncertain.
5. Classify failures.
   - Distinguish caller cancellation, timeout, transient transport failure, throttling, authentication, validation, and remote domain failure.
   - Preserve enough structured context for the application to decide its response.
6. Apply resilience deliberately.
   - Retry only operations and failures that are safe to repeat.
   - Honor server retry guidance and use bounded backoff with jitter.
   - Use circuit breaking or concurrency limits only when the dependency behavior warrants them.
7. Protect trust boundaries.
   - Validate user-controlled destinations before sending requests.
   - Reject unsafe schemes, loopback, link-local, private, and metadata endpoints unless explicitly required.
   - Scope propagated credentials to the intended service.
8. Add observability.
   - Record dependency name, operation, duration, outcome, and retry count.
   - Redact credentials, sensitive headers, query values, and payloads.
9. Propose validation.
   - Check success, timeout, cancellation, retry safety, throttling, malformed responses, unsafe destinations, and redaction.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation | Decision |
|---|---|
| Operation is not idempotent | Do not retry unless an idempotency contract makes repetition safe. |
| Server returns retry guidance | Honor it within configured bounds. |
| Caller cancels | Stop work and do not report a dependency failure. |
| Destination comes from user input | Apply SSRF-safe validation before resolution and connection. |
| Response contract differs from application needs | Map it at the integration boundary. |

## Constraints

- Do not instantiate and dispose `HttpClient` for each request.
- Do not retry every failure or use unbounded retries.
- Do not forward incoming credentials to arbitrary destinations.
- Do not log request or response bodies by default.
- Do not convert all remote failures into one undifferentiated exception.

## Completion Criteria

- Client lifetime, timeout, and cancellation behavior are explicit.
- Retry policy matches operation semantics.
- Authentication and destinations respect trust boundaries.
- Remote contracts do not leak into business models accidentally.
- Proposed checks cover resilience, security, and telemetry.