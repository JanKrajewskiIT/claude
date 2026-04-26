---
name: autosave-store
description: Build a synced/autosave store for user-owned remote documents (e.g. portfolio). Use when a feature has long-lived editable data with debounced server persistence and a save-status surface.
---

Normative constraints: `state-and-data-flow`, `velvet-consumer-frontend`, `persisted-keys`, `frontend-async-ux`.

## Standard workflow

1. Define typed document shape in `src/models/<Doc>.ts` (default export)
2. In `src/store/<feature>.ts`, call `createSyncedStore({ key, defaultData, normalize?, fetch, save })` from VelvetUi
3. Derive nested-collection actions per array field with `synced.collectionActions<T>('<field>')`; export `add/update/remove` per collection
4. Re-export `data`, `setData`, `saveStatus` (`AutosaveStatus`) from the store module
5. In the page component, react to `saveStatus` with a `createEffect`: throttle success toasts via `lastSuccessToastAt`; show error toasts immediately

## Conventions

- Persisted/local key follows `<app>-<feature>` (e.g. `<app>-portfolio`)
- `normalize` strips fields the client owns and the server should not echo back (e.g. identity fields recomputed from `useAuth()`)
- `save(data, signal)` MUST honor `signal` for cancellable debounced requests
- Collection items addressable by stable `id`; create with `crypto.randomUUID()` at insertion

## Component composition

- Page consumes `data()` and per-collection actions; never bypass them to mutate the store
- Forms get the doc through accessor + setter; field updaters use typed `handleFieldChange<K extends keyof S>(field: K, value: S[K])`
- Identity fields (firstName/lastName/email) come from `useAuth()`, merged at the API-mapping helper, not stored

## Before finishing

- `saveStatus` toast pattern is idempotent (no double-fire on focus/visibility changes)
- `fetch` runs once per session; store is not invalidated needlessly
- `normalize` strips every server-echoed field the client owns
