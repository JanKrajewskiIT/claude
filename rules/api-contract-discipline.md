---
paths:
  - '**/*'
---

# API Contract Discipline

## Ownership

- Request/response DTOs belong to the slice that owns the endpoint
- Never expose EF entities or persistence types on the wire
- Keep contracts next to the endpoint, not in shared folders

## Shape

- Required vs optional fields modeled explicitly; no vague nullability
- Stable semantic names over persistence-driven names
- Payloads carry business meaning, not UI transient state
- Normalize empty/missing values intentionally; do not let serializer defaults define the contract

## Mapping

- Map transport ↔ domain ↔ persistence explicitly at the slice boundary
- Frontend transport quirks must not leak into domain logic
- Persistence-only fields must not leak into API responses
