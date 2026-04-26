---
paths:
  - 'src/**/*.ts'
  - 'src/**/*.tsx'
  - 'demo/**/*.ts'
  - 'demo/**/*.tsx'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# State and Data Flow

## Separate UI State from Server State

- Keep ephemeral UI state (`open`, selection, local draft mode, highlighted item) in local signals or focused stores
- Keep server-owned collections and remote async state in query signals; do not mirror fetched query data into ad hoc writable signals unless you are creating an intentional local draft
- Persist only state that should survive navigation or reload, such as user selection, filters, or layout preferences

## Prefer Shared State Primitives

- Use shared helpers such as `createPersistedSignal`, `createSelectionStore`, `createEntityStore`, or query helpers before inventing one-off store shapes
- In app code built on VelvetUi query primitives, prefer `createAppQuery`, `createAppMutation`, and `invalidateQuery` over hand-rolled async state
- Namespace persisted storage keys with a stable feature prefix
- Reuse shared collection/store helpers when the shape is generic; do not hand-roll the same entity or selection pattern per feature

## Query Key and Watch Discipline

- Query keys must include every input that changes the remote result
- `watch` dependencies and query-key inputs must describe the same reactive inputs
- When a query requires a selected id, mode, or enabled toggle, gate it with `enabled` instead of letting the request fire with placeholder values
- Normalize default filters and empty values before they reach the API boundary so equivalent UI states produce equivalent query keys and requests

## Mutation and Invalidation Discipline

- Mutations should invalidate only the query keys affected by the write
- When a feature touches the same query family from multiple mutations, centralize invalidation in a local helper instead of repeating scattered key lists
- Prefer query invalidation or explicit cache updates over duplicating server state into parallel local stores

## API Boundary Mapping

- Map UI models to API contracts in a dedicated helper near the mutation or client boundary, not inline inside JSX or event handlers
- Keep result-to-form and form-to-request transforms in named helpers rather than anonymous callback bodies
- Keep transport normalization at the boundary: unwrap collection envelopes, coerce optional fields, and translate app-specific draft shapes before the request is sent
- Do not leak transport-only naming or nullability rules deep into view components

## Mapping Helper Naming

- Form -> request: `build<Domain>FromForm(state, existing?)` or `map<Domain>ToApi(domain, ...)`
- Server -> form: `map<Domain>ToFormState(domain)` / `mapParseResultToForm(parsed)`
- Use VelvetUi normalizers (`orEmpty`, `emptyToNull`, `numberToString`, `parseFloatOrNull`) for boundary coercion; do not write `String(value ?? '')` inline
- A helper used by more than one feature MUST be hoisted to a shared module; never duplicate the same `mapXToApi` between two `store/<feature>.ts` files
- Use `unwrapCollectionResponse(...)` from VelvetUi for any endpoint that returns an envelope; apply it consistently across stores
