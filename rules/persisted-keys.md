---
paths:
  - 'src/**/*.ts'
  - 'src/**/*.tsx'
---

# Persisted Storage Keys

## Naming

- App-owned keys MUST be prefixed with the app slug: `<app>-`
- Pattern: `<app>-<feature>-<concern>` in kebab-case (e.g. `<app>-organizer-statuses`)
- Library-managed keys (theme, locale, OIDC return URL) keep their library names
- Cross-redirect ephemeral session-storage blobs use `<feature>_<purpose>` snake_case (e.g. `calendar_oauth_callback`) and MUST be exported as named constants

## Location

- Persisted signals MUST live in `src/store/<feature>.ts`, never in component modules
- Selection factories owning persisted state expose them through their returned API; consumers don't import the persisted signal directly

## Discipline

- Default values MUST be set when the persisted signal is created; never rely on `undefined` checks downstream
- When the persisted shape changes, write a one-shot migration in the same module rather than scattering `try/catch` across consumers
- Prefer `createPersistedSignal` from VelvetUi over hand-rolled `localStorage.setItem`
