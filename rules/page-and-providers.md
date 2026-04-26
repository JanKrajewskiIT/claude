---
paths:
  - 'src/pages/**/*.tsx'
  - 'src/App.tsx'
  - 'src/index.tsx'
---

> Type: Rule (normative constraints)

# Page, Providers, and Auth Guards (consumer apps)

## Lazy Routes

- Every route component in the router MUST be `lazy(() => import('~/pages/<Name>'))`
- Page modules stay thin (~10–25 lines): wrap with `<Page>` + selection providers + the real feature component imported from `~/components/<feature>/<Feature>/<Feature>`

## Canonical Page Layering

```
<Page roles={[...]} unauthorizedBehavior="redirect">
  <FeatureSelectionContext.Provider value={createFeatureSelection()}>
    <Feature />
  </FeatureSelectionContext.Provider>
</Page>
```

- `<Page>` is the auth boundary; selection providers MUST sit INSIDE `<Page>` so unauthenticated visitors do not allocate feature state
- Public routes (landing, privacy, 404) skip `<Page>` entirely
- Feature-selection factories live in `src/store/<feature>.ts` and expose a typed Context plus a `use<Feature>Selection()` hook that throws on missing provider

## Layout Composition

- Authenticated routes share a `MainLayout` mounted as a layout-route in the router
- Unauthenticated flows (e.g. onboarding) sit OUTSIDE the main layout
- Navigation items are declared as a typed config (`NavItemConfig[]`) with `requiredRoles?: Role[]`; layout consumes them through a single resolver

## Provider Composition Order

`ErrorBoundary` -> `ThemeProvider` -> `I18nProvider` -> `QueryClientContext` -> `AuthProvider` -> `ToastProvider` -> app tree.
Use `VelvetProvider` to get this order automatically; do not reassemble providers manually unless replacing one specific layer.
