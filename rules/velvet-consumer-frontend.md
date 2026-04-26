---
paths:
  - '**/*'
---

# VelvetUi Consumer Frontend

Cross-cutting data/query/mapping rules → `rules/state-and-data-flow`. This file covers consumer-specific structure only.

## App architecture

- Consumer apps treat VelvetUi as the source of reusable primitives, shared surfaces, common interaction helpers
- Prefer importing from `@jankrajewskiit/ui` before creating local UI primitives or re-implementing shared behaviors
- App-specific business logic stays in the owning feature; prefer feature-owned hooks/stores over global state when the behavior is local
- Compose forms, dialogs, sheets, tables, common layouts from VelvetUi primitives first
- Compose around library primitives instead of restyling primitive internals from host CSS

## Folder layout

```
src/
  api/client.ts                   # createApiClients(...) — single source of typed clients
  components/<feature>/<Component>/<Component>.tsx (+ .module.css)
  store/<feature>.ts              # data hooks + selection factory + Context for the feature
  models/<DomainType>.ts          # one type per file, default export, optional translation/color maps
  pages/<Feature>.tsx             # thin: <Page> + Provider + <Feature/>
  i18n/locales/{en,pl}.ts         # nested namespaced dictionaries
  config/auth.ts                  # OidcAuthConfig
```

- File name MUST match folder name (`Foo/Foo.tsx`); no `index.ts` re-exports
- One model per file in `src/models/`; default-export the type
- One `store/<feature>.ts` per backend feature; co-locate query hooks, mutation hooks, selection factory, selection Context

## Hook naming

- Data hooks: `use<Subject><Verb>Query` returning `AppQueryResult<T>` (e.g. `useOffersQuery`, `useUserProfileQuery`)
- Mutations: `use<Verb><Subject>Mutation` returning `AppMutationResult<TData, TVars>` (e.g. `useAddOfferMutation`)
- Selection factories: `create<Feature>Selection()` returning `{ accessors, setters, helpers }`

## Enums & models

- Enum-style constants use `as const` object pattern, NOT TypeScript `enum`:
  ```ts
  const OfferStatus = { New: 'New', Saved: 'Saved' } as const;
  type OfferStatus = (typeof OfferStatus)[keyof typeof OfferStatus];
  export default OfferStatus;
  ```
- Each enum SHIPS a `Record<X, DictKey>` named `<X>TranslationKeys` in the same file
- When the enum has a UI-color story, ship `<X>Colors: Record<X, 'info' | 'warning' | 'success' | 'error'>` next to it

## Typed i18n

- Wrap VelvetUi i18n in a single app module (e.g. `src/store/i18n.tsx`) using `createTypedI18n<RawDictionary>()` from VelvetUi
- App code MUST import `useI18n` and `DictKey` from this app module — NEVER directly from `@jankrajewskiit/ui`
- Translation keys are nested namespaced: `<feature>.<group>.<key>`
- Consumer-app user-facing copy lives in the app's typed dictionaries; do not hardcode visible copy in feature components
- Enum-like models keep label/translation-key maps close to the model when the labels are app-owned
