---
name: state-and-query-playbook
description: Shared workflow for Solid app state, persisted selection, query hooks, mutations, invalidation, and API-boundary mapping. Also the default playbook for VelvetUi consumer-app feature work. Use when building or refactoring app stores and data flows.
---

Normative constraints: `state-and-data-flow`, `reactivity-performance`, `solidjs-tsx`, `velvet-consumer-frontend`, `i18n`.

## Consumer-app workflow

When the change is in an app built on `@jankrajewskiit/ui`:

1. Find the owning feature area first (components, stores, models, pages, app-local i18n)
2. Reuse VelvetUi primitives before creating local UI wrappers
3. Server state → shared query primitives; local interaction state → signals or focused stores
4. Add request/response mapping helpers near the feature store or API boundary
5. Route visible copy through the app's typed i18n module — never import `useI18n` directly from `@jankrajewskiit/ui`

## Standard workflow

1. Identify which state is local UI, persisted preference, or server-owned
2. Server data in query hooks; introduce local writable state only for drafts, transient selection, interaction state
3. Build the query key from the same reactive inputs that drive the request
4. Normalize API params and payloads in small helpers near the query/mutation boundary
5. Centralize invalidation for the feature before wiring multiple mutations

## Preferred building blocks

- `createPersistedSignal` — reload-stable filters, tabs, selected ids
- `createSelectionStore` — common filter/sort/selected-item flows
- `createEntityStore` — keyed in-memory collections
- `createAppQuery` — feature-owned remote reads
- `createAppMutation` — feature-owned writes
- `invalidateQuery` — scoped invalidation after writes
- Small local mapping helpers at the API boundary

## Design checklist

- Does this state belong to UI, local draft, or server cache?
- Would a shared store/query helper express this pattern more clearly?
- Does the query key fully describe the request?
- Are default values normalized consistently between UI state and API params?
- Are invalidations scoped to feature keys that actually changed?

## Before finishing

- Re-read affected query keys and mutation invalidations together
- Check `enabled` and `watch` cannot produce accidental fetches
- Move payload-shaping code out of JSX/event handlers into local helpers
- Persisted keys stay feature-namespaced and stable across reloads
