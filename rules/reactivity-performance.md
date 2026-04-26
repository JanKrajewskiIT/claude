---
paths:
  - 'src/**/*.tsx'
  - 'src/**/*.ts'
---

# Reactivity & Performance

## Effects vs memos

- `createMemo` for pure derived values; do NOT use `createEffect` to mirror one signal into another
- `createEffect` only for real side effects (DOM APIs, subscriptions, timers, network boundaries, imperative library bridges)
- When an effect depends on specific sources, use `on(source, ...)` with explicit dependencies
- `{ defer: true }` for sync effects that should skip mount-time eager writes
- Effects mirroring `props`/signals into internal signals MUST use `createEffect(on(source, fn, ...))`; never rely on implicit tracking
- When multiple internal signals must stay in sync with the same source, consolidate into one `on(source, ...)` effect with a single `batch(...)`; do not split into parallel effects re-triggering the same upstream

## Multi-signal updates

- Wrap logically single transitions touching multiple signals in `batch(...)`
- Batch state + callback notifications when they represent one user action
- No intermediate invalid states observable between sequential setters
- Inside `setX(prev => ...)`, never call other setters or imperative side effects depending on the new value; compute the next value and branching flags first, then `batch(...)` the setters together

## High-frequency events

- For `scroll`/`resize`/`wheel`/`mousemove`/`pointermove`/`touchmove`/drag-resize, route signal writes through `requestAnimationFrame` with explicit cancellation in `onCleanup`
- Store the latest event payload in a local variable (`pendingX`, `pendingClientX`) and commit inside the rAF callback; never `set*` synchronously from the raw event
- On drag/resize end, flush any in-flight rAF with the last pending value before clearing the scheduler
- `{ passive: true }` for scroll/wheel/touch listeners that never call `preventDefault`
- For text-query / preview workloads, use `createDeferred` or debounced `setTimeout`
- Keep handlers small; defer expensive computations outside the hot path

## JSX handlers & reactivity

- Extract inline JSX handlers into named factories only when captured values are stable for the handler lifetime
- When a handler needs reactive reads from `props`/signals, keep it inline so it executes in event scope
- Trivial reactive pass-through wrappers are allowed and preferred:
  - `onClick={() => props.onClose()}`
  - `onSubmit={(event) => props.onSubmit(event)}`
- Do not move reactive prop reads into top-level handler factories evaluated during render — triggers `solid/reactivity` warnings, can freeze stale values
- In `<For>`, factory handlers should capture plain item/index values, not deferred reads from reactive owners

## Timers, RAF, cleanup

- Every `setTimeout`/`setInterval`/`requestAnimationFrame`/observer/listener has deterministic cleanup via `onCleanup`
- Cancel pending raf/timers before scheduling replacements when only the latest run should win
- Never leave subscriptions active across unmount

## Imperative bridges

- For imperative libraries (charts/editors), keep imperative mirrors (`let latestX`) only when used by non-reactive callbacks
- Don't mirror reactive values imperatively unless avoiding stale closures in third-party callbacks
- Keep bridge code localized, cleaned up in one effect lifecycle
