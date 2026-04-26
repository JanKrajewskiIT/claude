---
name: state-and-query-playbook
description: Shared workflow for Solid app state, persisted selection, query hooks, mutations, invalidation, and API-boundary mapping. Also the default playbook for VelvetUi consumer-app feature work. Use when building or refactoring app stores and data flows.
---

> Type: Skill (operational playbook)

Use this playbook when changing feature stores, query hooks, API-backed selection state, or mutation flows — both inside VelvetUi and in any application that consumes it.

Normative constraints live in `rules/state-and-data-flow`, `rules/reactivity-performance`, `rules/solidjs-tsx`, `rules/velvet-consumer-frontend`, and `rules/i18n`.

## Consumer-App Workflow

When the change is in an app built on `@jankrajewskiit/ui`:

1. Find the owning feature area first: feature components, stores, models, pages, and app-local i18n
2. Reuse VelvetUi primitives before creating local UI wrappers
3. Put server state in shared query primitives and keep local interaction state in signals or focused stores
4. Add request and response mapping helpers near the feature store or API boundary
5. Route visible copy through the app's typed i18n module — never import `useI18n` directly from `@jankrajewskiit/ui`

## Standard Workflow

1. Identify which state is local UI state, which is persisted preference state, and which is server-owned state
2. Keep server data in query hooks; introduce local writable state only for drafts, transient selection, or interaction state
3. Build the query key from the same reactive inputs that drive the request
4. Normalize API params and payloads in small helpers near the query or mutation boundary
5. Centralize invalidation for the feature before wiring multiple mutations

## Preferred Building Blocks

- `createPersistedSignal` for reload-stable filters, tabs, and selected ids
- `createSelectionStore` for common filter/sort/selected-item flows
- `createEntityStore` for keyed in-memory collections
- `createAppQuery` for feature-owned remote reads
- `createAppMutation` for feature-owned writes
- `invalidateQuery` for scoped invalidation after writes
- Small local mapping helpers at the API boundary for request shaping and response normalization

## Design Checklist

- Does this state belong to the UI, local draft, or server cache?
- Would a shared store/query helper express this pattern more clearly?
- Does the query key fully describe the request?
- Are default values normalized consistently between UI state and API params?
- Are invalidations scoped to the feature keys that actually changed?

## Before Finishing

- Re-read the affected query keys and mutation invalidations together
- Check that `enabled` and `watch` logic cannot produce accidental fetches
- Move any payload-shaping code out of JSX and event handlers into local helpers
- Make sure persisted keys stay feature-namespaced and stable across reloads
