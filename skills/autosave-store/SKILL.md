---
name: autosave-store
description: Build a synced/autosave store for user-owned remote documents (e.g. portfolio). Use when a feature has long-lived editable data with debounced server persistence and a save-status surface.
---

> Type: Skill (operational playbook)

Use this playbook when a feature owns a single user document that should be loaded once, edited locally, and autosaved back to the server.

Normative constraints live in `state-and-data-flow`, `velvet-consumer-frontend`, `persisted-keys`, and `frontend-async-ux`.

## Standard Workflow

1. Define the typed document shape in `src/models/<Doc>.ts` with a `default export`
2. In `src/store/<feature>.ts`, call `createSyncedStore({ key, defaultData, normalize?, fetch, save })` from VelvetUi
3. Derive nested-collection actions per array field with `synced.collectionActions<T>('<field>')`; export `add/update/remove` per collection
4. Re-export `data`, `setData`, `saveStatus` (`AutosaveStatus`) from the store module
5. In the page component, react to `saveStatus` with a `createEffect`: throttle success toasts by tracking `lastSuccessToastAt`; show error toasts immediately

## Required Conventions

- The persisted/local key follows `<app>-<feature>` (e.g. `<app>-portfolio`)
- `normalize` strips fields that the client owns and the server should not echo back (e.g. identity fields recomputed from `useAuth()`)
- `save(data, signal)` MUST honor `signal` so debounced requests are cancellable
- Collection items are addressable by stable `id`; create new items with `crypto.randomUUID()` at insertion time

## Component Composition

- The page consumes `data()` and the per-collection actions; never bypass them to mutate the store
- Forms inside the page get the doc through accessor + setter; field updaters use the typed `handleFieldChange<K extends keyof S>(field: K, value: S[K])` shape
- Identity fields (firstName/lastName/email) come from `useAuth()` and are merged at the API-mapping helper, not stored

## Before Finishing

- Check the `saveStatus` toast pattern is idempotent (no double-fire on focus/visibility changes)
- Confirm `fetch` runs once per session and the store is not invalidated needlessly
- Verify `normalize` strips every server-echoed field the client owns
