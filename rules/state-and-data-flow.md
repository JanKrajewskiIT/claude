---
paths:
  - 'src/**/*.ts'
  - 'src/**/*.tsx'
  - 'demo/**/*.ts'
  - 'demo/**/*.tsx'
---

# State & Data Flow

## Separate UI state from server state

- Ephemeral UI state (`open`, selection, local draft, highlighted item) → local signals or focused stores
- Server-owned collections and remote async state → query signals; do not mirror fetched data into ad-hoc writable signals unless creating an intentional local draft
- Persist only state that should survive navigation/reload (selection, filters, layout preferences)

## Prefer shared state primitives

- Use `createPersistedSignal`, `createSelectionStore`, `createEntityStore`, query helpers before inventing one-off store shapes
- In app code on VelvetUi query primitives, prefer `createAppQuery`, `createAppMutation`, `invalidateQuery` over hand-rolled async state
- Namespace persisted keys with a stable feature prefix
- Reuse shared collection/store helpers when the shape is generic; do not hand-roll the same entity/selection pattern per feature

## Query keys & watch

- Query keys MUST include every input that changes the remote result
- `watch` dependencies and query-key inputs describe the same reactive inputs
- When a query requires a selected id/mode/enabled toggle, gate with `enabled` instead of letting it fire with placeholder values
- Normalize default filters and empty values BEFORE the API boundary so equivalent UI states produce equivalent query keys

## Mutations & invalidation

- Mutations invalidate ONLY the keys affected by the write
- When a feature touches the same query family from multiple mutations, centralize invalidation in a local helper
- Prefer query invalidation or explicit cache updates over duplicating server state into parallel local stores

## API boundary mapping

- Map UI models to API contracts in a dedicated helper near the mutation/client boundary, NOT inline in JSX/event handlers
- Keep result-to-form and form-to-request transforms in named helpers
- Keep transport normalization at the boundary: unwrap collection envelopes, coerce optional fields, translate app-specific draft shapes before the request
- Do not leak transport-only naming/nullability rules into view components

## Mapping helper naming

- Form → request: `build<Domain>FromForm(state, existing?)` or `map<Domain>ToApi(domain, ...)`
- Server → form: `map<Domain>ToFormState(domain)` / `mapParseResultToForm(parsed)`
- Use VelvetUi normalizers (`orEmpty`, `emptyToNull`, `numberToString`, `parseFloatOrNull`) for boundary coercion; do not write `String(value ?? '')` inline
- Helpers used by more than one feature MUST be hoisted to a shared module; never duplicate `mapXToApi` between two `store/<feature>.ts`
- Use `unwrapCollectionResponse(...)` from VelvetUi for envelope endpoints
