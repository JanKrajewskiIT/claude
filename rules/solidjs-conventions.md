# SolidJS Conventions

## Scope

- Apply this rule only to SolidJS components, primitives, and libraries.
- Apply `tsx-component-conventions` for component file, module, declaration, and composition rules.

## Reactivity

- Read reactive values inside the tracked scope that must update.
- Preserve property access on reactive props unless the repository uses a reactive-safe helper.
- Derive values directly instead of creating a signal for values that do not change.
- Use `createMemo` when a derived calculation is costly, shared by multiple consumers, or requires stable reactive caching.
- Do not use `createMemo` automatically for trivial derived expressions.
- Derive values directly or with memos instead of synchronizing writable copies with effects.
- Use effects for external side effects, not pure computation.
- Keep memos pure; emit warnings, logs, and storage writes from effects or event handlers.
- Do not create cache entries, start timers, or register observers inside a memo.
- Memoize allocating getters on public result objects, such as selectors or flattened lists, so consumers see stable identity between reads.
- Pass `() => value` to a setter whenever the signal type may itself be a function, and do not read the signal inside a public setter without `untrack` or a functional update.
- Handle each reactive prop through one reactive path; do not split its initial and later handling across `onMount` and `createEffect` with duplicated validation.
- Use explicit effect dependencies when only named sources should trigger work.
- Use `untrack` only when intentionally excluding a read from dependency tracking.
- Batch multi-signal updates that represent one atomic transition.
- Compute next values before setters instead of causing side effects inside setter callbacks.
- Clean up listeners, timers, observers, and subscriptions with the owning reactive scope.
- Pass a synchronous callback to a component prop and start asynchronous work inside it with a fire-and-forget call such as `mutate`; an `async` callback prop is reported as an async tracked scope.

## Props And Children

- Do not destructure reactive props when later updates must remain observable.
- Do not copy members of an object prop into local bindings during setup (`const { state } = props.model`); read through `props.model` at the use site or expose the needed value as a memo on the owner.
- Use `splitProps` to separate local props from attributes forwarded to an element.
- Use `mergeProps` or the repository convention when defaults must preserve reactive access.
- Resolve each defaulted prop in one place instead of repeating `props.value ?? DEFAULT` at every read.
- Use the `children` helper when children are read repeatedly, inspected, or transformed.
- Never mount the same resolved `JSX.Element` DOM nodes under multiple parents. Repeated content needs independent rendering or an inert presentation copy with unique or removed ids.
- Compose forwarded event handlers intentionally instead of silently replacing either handler.
- Spread forwarded attributes before component-owned attributes, or remove handler props the component owns from the forwarded set; a trailing `{...rest}` must never override an internal handler, `ref`, or `class`.

## JSX Control Flow

- Use `For` for keyed reactive collections whose items can move, appear, or disappear.
- Use `Index` only when positions remain stable and item values change independently.
- Use `Show`, `Switch`, and `Match` when they make reactive branches and fallback behavior explicit.
- Avoid large inline conditions and collection transformations that hide state ownership inside JSX.
- Render consumer render-prop children through `Show`, `Switch`, or `Match` instead of calling them inside a memo whose re-execution recreates the subtree on every data change.
- Return JSX from control-flow primitives instead of casting a memo or accessor to `JSX.Element`.
- Use one conditional-rendering idiom: `Show` for reactive branches, not `cond && <jsx />` or `cond ? <a /> : <b />` in JSX.

## State

- Keep transient interaction state near the smallest coordinating component.
- Keep server-owned data in the query or resource abstraction used by the repository.
- Create writable drafts only when editing requires divergence from the source value.
- Type a draft store with a mutable copy of the domain shape when the domain type is `readonly`; store path setters reject readonly properties, and consumers keep the readonly type.
- Change a list inside a store through one `produce` helper that takes the list name, not through generic path setters.
- Use stores for structured granular updates and signals for focused values.
- Keep persisted preferences separate from remote server state.
- Resolve the initial value of an uncontrolled input synchronously from its default, never from an effect with `defer: true`; the first render and form submission must already see it.
- Implement controlled/uncontrolled value ownership once as a shared primitive and reuse it, instead of re-implementing mirror effects (`createEffect(on(() => props.value, set, { defer: true }))`) per component.
- Do not create module-level signals, stores, or timer registries for shared UI state such as toasts or notifications; create them under a provider so they have an owner, a lifetime, and per-request isolation.
- Evaluate "now" and other time-dependent values lazily or from a ticking source instead of capturing them once at component creation.

## Components

- Follow existing component, prop, styling, and import conventions.
- Use semantic HTML before adding ARIA roles.
- Keep one exported component in each component file, subject to the private-component exception in `tsx-component-conventions`.
- Forward supported native attributes when building reusable element wrappers.
- Keep context providers focused on one coherent ownership boundary.
- Prefer props and composition for local relationships; use context for shared descendant ownership.
- Keep context values minimal and fail clearly when a required provider is missing.
- Expose derived collections as readonly values; do not allow consumers to mutate a memo's cached result outside reactive setters.
- When a contract requires a degraded fallback outside the provider, emit a development diagnostic so the missing provider stays observable.
- Read context only during synchronous setup under an owner; a function that callers may invoke from event handlers or asynchronous callbacks must receive the dependency explicitly instead of resolving it from context.
- Keep each component in its own module even when the library authors components without JSX through `createComponent`.
- Avoid wrappers that add no semantics, layout, behavior, or reusable boundary.

## Ownership And Lifecycle

- Create reactive primitives within the owner responsible for their lifetime.
- Use `onCleanup` for every owned listener, timer, observer, subscription, and imperative resource.
- Use `createRoot` only when intentionally creating a lifetime outside the current owner and expose an explicit disposal path.
- Make a primitive that creates effects or cleanups either require an owner and fail clearly without one, or create its own root with an explicit `dispose`; define one lifetime owner instead of offering both scope cleanup and manual disposal.
- Perform browser-only setup in `onMount` or behind an equivalent environment boundary.
- Access Web Storage through one guarded accessor that tolerates a missing API and a `SecurityError`, and use it in every primitive that persists data.

## DOM References

- Use a local reference when the element is read only by event handlers or imperative calls.
- Assign a local reference through a callback ref, `ref={(element) => { node = element; }}`; a bare `let node; ref={node}` is never seen as assigned by static analysis.
- Use a signal when element availability drives reactive measurement or positioning.
- Preserve callback-ref semantics when forwarding a DOM reference.
- Do not mix local and reactive ownership for the same element reference.

## Async Work

- Use the repository query abstraction or `createResource` for reactive asynchronous reads.
- Do not put an asynchronous function directly in `createEffect`.
- Track loading, empty, failure, and stale states explicitly.
- Propagate cancellation where the underlying API supports it.
- Invalidate pending UI operations when their surface closes, reopens, or is disposed; guard consumer callbacks and local state writes with the same operation identity.
- Route promise completions and dependency events through the same state-transition policy so one cannot bypass the other's invalidation guards.
- Keep request mapping and payload normalization outside JSX event markup.

## Loading And Failure Boundaries

- Use `Suspense` where descendants intentionally coordinate asynchronous readiness behind one fallback.
- Keep local loading indicators outside `Suspense` when previously available content should remain visible.
- Use `ErrorBoundary` at an ownership boundary that can present a meaningful recovery action.
- Reset an error boundary only when the failed operation or relevant input can produce a different result.
- Use lazy loading at route or substantial feature boundaries rather than fragmenting small components.
- Keep resource errors observable and do not convert failures into indefinite loading or empty states.

## Server Rendering

- Keep the initial render deterministic between server and client.
- Do not read `window`, `document`, storage, layout, or other browser-only state during server rendering.
- Defer browser-dependent behavior until mount unless an isomorphic abstraction owns it.
- Preserve hydration structure and avoid client-only branches that replace initial markup unexpectedly.
- When server rendering is not supported, initialize signals from synchronous browser state behind an environment guard instead of rendering a default and correcting it after mount.
- Do not keep request-scoped data in a module-level default instance, such as a lazily created query client, when the library may run on a server.

## High-Frequency Events

- Schedule reactive writes from pointer, scroll, resize, and drag streams at an appropriate frame or time boundary.
- Keep the latest pending input and flush the final value when an interaction ends.
- Use passive listeners only when the handler never prevents the default action.
- Cancel scheduled frames, timers, and listeners when ownership ends.

## Completion Criteria

- Reactive props and values remain observable after component setup.
- Effects perform only external side effects, and memos stay pure.
- Every listener, timer, observer, and subscription is released by its owning scope.
- Shared UI state lives under a provider with an owner, not in module-level signals or stores.
- Asynchronous reads expose loading, empty, failure, and stale states, and stale results cannot overwrite newer state.
- Server and client initial renders agree when server rendering is supported.
