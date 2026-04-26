---
paths:
  - '**/*'
---

# VelvetUi Runtime Config Singleton

VelvetUi exposes a module-level `runtimeConfig` (`src/providers/velvet-config.ts`) read by `createHttpClient` to inject the bearer token and base URL.

## Bootstrap order (consumer apps)

1. Call `configureVelvet({ ... })` (or use `bootstrapVelvetApp`) BEFORE any HTTP client construction or component render
2. Mount `VelvetProvider` at the root with `themeStorageKey`, `localeStorageKey`, `localeDictionaries`, `queryDefaults`
3. Only then mount the application tree

`bootstrapVelvetApp({ authConfig, root, app, onBeforeSanitizeAuthParams })` is the canonical entrypoint; do not re-implement the boot sequence.

## Forbidden

- Reading `runtimeConfig` directly from app code (use `getVelvetRuntimeConfig` if a value is genuinely needed)
- Calling `configureVelvet` from inside a component or effect
- Constructing `createHttpClient` before `configureVelvet` has run
- Treating VelvetUi as SSR-safe; the singleton is browser-scoped

## Module-level mutable state

VelvetUi reserves module-level mutable signals for: toast/notification surface (`src/components/feedback/Toast/Toast.tsx`) and the runtime config singleton. All other state MUST be Context- or hook-scoped.
