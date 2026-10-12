---
name: api-contract-design
description: Design, evolve, or review stable HTTP API contracts. Use when the primary outcome is consumer-visible protocol behavior such as request and response DTOs, validation errors, pagination, filtering, nullability, idempotency, concurrency, compatibility, versioning, or OpenAPI behavior.
---

# API Contract Design

## Goal

- Create an explicit contract that clients can consume without knowing persistence details.
- Evolve observable behavior without accidental breaking changes.

## Do Not Use

- Use `aspnet-core-endpoint` to implement an agreed contract in ASP.NET Core.
- Use `dotnet-command-query-handler` for application use-case logic behind the contract.
- Use `ef-core-persistence` for storage queries and write paths.

## Workflow

1. Identify consumers and operation semantics.
   - Define the user outcome, resource ownership, authorization boundary, and expected call frequency.
   - Stop when consumer intent, ownership, or authorization policy is unresolved.
   - Choose HTTP method and status codes from operation semantics.
2. Define request input.
   - Separate route identity, query options, headers, and body data.
   - State required, optional, nullable, defaulted, and mutually exclusive fields explicitly.
   - Bound collection sizes, text lengths, page sizes, and filter complexity.
3. Define response output.
   - Return purpose-built contracts instead of persistence entities.
   - Use stable identifiers and explicit representations for dates, money, enums, and links.
   - Distinguish absent, unknown, empty, and redacted values.
4. Define failures.
   - Use one machine-readable error shape across the API.
   - Give validation failures stable field paths and codes.
   - Avoid exposing stack traces, internal type names, or sensitive values.
5. Define collection behavior.
   - Specify ordering before pagination.
   - Choose offset pagination for bounded data and cursor pagination for changing or large datasets.
   - Define filter syntax, maximum page size, continuation behavior, and empty results.
6. Define write safety.
   - Specify idempotency for retried creation or commands when duplicate execution matters.
   - Use an explicit concurrency token when clients can overwrite newer state.
   - Document retry-safe and non-retry-safe failures.
7. Assess compatibility.
   - Compare changes from the consumer's perspective, including generated clients.
   - Prefer additive optional fields and new endpoints over changing established meaning.
   - When adapting an existing API to a redesigned client, list each needed call as a contract matrix of existing, extended, or new before editing handlers.
   - Return the identifier a client needs next from a create-or-update call instead of an empty success.
   - Version only when compatibility cannot be preserved cleanly.
8. Document the contract.
   - Keep OpenAPI metadata, examples, validation, and runtime behavior aligned.
   - Declare response types in endpoint metadata; without them a generated schema covers only requests and clients type responses by hand.
   - Use [`references/examples.md`](references/examples.md) when concrete shapes clarify decisions.
9. Propose validation.
   - Check serialization, validation, authorization, status codes, error shapes, pagination, retries, concurrency, and generated clients.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation                                                                          | Decision                                                                                    |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Field may be omitted but cannot be null                                            | Model optionality separately from nullability.                                              |
| Dataset changes during traversal                                                   | Prefer stable cursor pagination.                                                            |
| Client may retry a non-idempotent command                                          | Define an idempotency contract.                                                             |
| Multiple writers may update one resource                                           | Require an optimistic concurrency token.                                                    |
| Existing consumers can misinterpret a change                                       | Treat it as breaking even if serialization still succeeds.                                  |
| Client sends an empty or default identifier for a resource that does not exist yet | Treat it as absent at the boundary and create or upsert.                                    |
| A new request field must not break existing clients                                | Give it a default and keep it optional on the wire.                                         |
| The client models an action as a toggle                                            | Make the operation toggle, or give it an explicit inverse; do not reject the repeated call. |

## Constraints

- Do not expose database entities or ORM navigation graphs.
- Do not return success with an error encoded only in the response body.
- Do not use unspecified ordering with pagination.
- Do not reuse one DTO across unrelated operations merely to reduce file count.
- Do not publish fields that the authorization policy cannot consistently protect.

## Completion Criteria

- Inputs, outputs, errors, and status codes are unambiguous.
- Optionality, nullability, defaults, and limits are explicit.
- Pagination and write retry behavior are deterministic.
- Compatibility impact is classified from the consumer perspective.
- Runtime behavior and API documentation agree.
