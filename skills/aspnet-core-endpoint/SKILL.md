---
name: aspnet-core-endpoint
description: Implement or review ASP.NET Core controller or minimal API endpoints for an agreed HTTP contract. Use when wiring routes, transport DTOs, validation, authorization policies, OpenAPI metadata, status codes, error mapping, or endpoint-focused validation.
---

# ASP.NET Core Endpoint

## Goal

- Deliver a secured and documented endpoint whose runtime behavior matches its public API contract.

## Do Not Use

- Use `api-contract-design` when the HTTP contract is not yet agreed.
- Use `dotnet-command-query-handler` for the application use case behind the endpoint.
- Use `dotnet-vertical-slice` when delivering the complete feature across endpoint, handler, and persistence.

## Workflow

1. Inspect the agreed API contract, neighboring endpoints, routing style, authorization, validation, error rendering, OpenAPI conventions, application boundary, and tests.
2. Confirm route, method, statuses, shapes, authorization, idempotency, and compatibility with `api-contract-design`.
   - Stop when the contract or security policy is missing.
3. Define transport DTOs separately from domain and persistence types and map inputs to the repository's use-case contract.
4. Enforce the repository's specific operation policy at the endpoint or owning authorization boundary.
   - Treat authentication, route guards, and broad roles as insufficient when the contract requires a narrower permission or resource check.
5. Configure validation for body, route, query, and header inputs using established filters, binders, endpoint filters, or validation libraries.
6. Return semantic statuses and headers, including `Location` for creation, no body for true no-content responses, and `202` only for asynchronous work.
7. Trace every expected failure reachable from the operation and map it through the owning host error mechanism.
   - Extend `dotnet-error-handling` when a new stable code or category is required.
8. Align runtime success, stable errors, authorization requirements, DTOs, and generated OpenAPI.
   - Define shared error responses centrally and keep operation-specific responses local.
9. Keep business orchestration in the owning application use case and stop on ambiguity that could expose data or change consumer behavior.
10. Propose focused validation for serialization, malformed input, constraints, authorization, statuses, headers, errors, and use-case mapping.

## Decision Rules

| Situation                                     | Decision                                                                 |
| --------------------------------------------- | ------------------------------------------------------------------------ |
| Minimal API and controllers both exist        | Follow the owning feature's established style.                           |
| Endpoint accepts a body                       | Keep transport validation and mapping at the host boundary.              |
| Operation creates a retrievable resource      | Return the agreed creation status and `Location`.                        |
| Failure has a stable shared mapping           | Reuse the centralized host handler.                                      |
| Resource authorization depends on loaded data | Enforce it at the boundary that owns the authoritative resource context. |

## Constraints

- Do not expose persistence entities, tracked objects, or raw framework exceptions.
- Do not rely on authentication alone when operation or resource authorization is required.
- Do not document responses the runtime cannot produce or omit known runtime failures.
- Do not duplicate shared errors across every operation when OpenAPI can own them centrally.
- Do not block asynchronous request paths or lose request cancellation.
- Do not invent the public contract or move business orchestration into the endpoint.

## Completion Criteria

- Route, method, statuses, headers, validation, and DTOs match the contract.
- Authorization is enforced at the correct operation and resource boundary.
- Transport mapping contains no persistence or business orchestration.
- Every expected failure has intentional runtime and OpenAPI behavior.
- Cancellation reaches cancellable application and integration boundaries.
- Proposed checks cover valid, invalid, unauthorized, forbidden, and applicable conflict or not-found paths.
