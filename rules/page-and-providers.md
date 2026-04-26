---
paths:
  - 'src/pages/**/*.tsx'
  - 'src/App.tsx'
  - 'src/index.tsx'
---

# Page, Providers, Auth Guards (consumer apps)

## Lazy routes

- Every route component MUST be `lazy(() => import('~/pages/<Name>'))`
- Page modules stay thin (~10–25 lines): `<Page>` + selection providers + the real feature component from `~/components/<feature>/<Feature>/<Feature>`

## Canonical page layering

```tsx
<Page roles={[...]} unauthorizedBehavior="redirect">
  <FeatureSelectionContext.Provider value={createFeatureSelection()}>
    <Feature />
  </FeatureSelectionContext.Provider>
</Page>
```

- `<Page>` is the auth boundary; selection providers MUST sit INSIDE so unauthenticated visitors do not allocate feature state
- Public routes (landing, privacy, 404) skip `<Page>`
- Selection factories live in `src/store/<feature>.ts` and expose a typed Context + `use<Feature>Selection()` hook that throws on missing provider

## Layout composition

- Authenticated routes share a `MainLayout` mounted as a layout-route
- Unauthenticated flows (e.g. onboarding) sit OUTSIDE the main layout
- Navigation items declared as typed config (`NavItemConfig[]`) with `requiredRoles?: Role[]`; layout consumes them via a single resolver

## Provider order

`ErrorBoundary` → `ThemeProvider` → `I18nProvider` → `QueryClientContext` → `AuthProvider` → `ToastProvider` → app tree.

Use `VelvetProvider` for this order automatically; do not reassemble manually unless replacing one specific layer.
