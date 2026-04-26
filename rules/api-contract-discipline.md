---
paths:
  - '**/*'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# API Contract Discipline

## Contract Ownership

- Request and response DTOs belong to the feature or slice that owns the endpoint
- Do not expose EF entities, persistence models, or infrastructure-only types directly on the wire
- Keep transport contracts close to the endpoint and handler instead of scattering them across unrelated shared folders

## Shape and Semantics

- Model required versus optional fields explicitly; do not use vague nullability when the field is truly required
- Prefer stable semantic names over persistence-driven names
- Keep API payloads focused on business meaning, not UI-only transient state
- Normalize empty strings and missing values intentionally; do not let accidental serializer behavior define the contract

## Mapping Discipline

- Map between transport contracts, domain inputs, and persistence shapes explicitly in the owning slice or feature boundary
- Do not let frontend transport quirks leak deep into domain logic
- Do not let persistence-only fields leak back into API responses unless they are part of the actual product contract
