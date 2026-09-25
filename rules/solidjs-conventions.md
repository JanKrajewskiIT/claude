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
- Use explicit effect dependencies when only named sources should trigger work.
- Use `untrack` only when intentionally excluding a read from dependency tracking.
- Batch multi-signal updates that represent one atomic transition.
- Compute next values before setters instead of causing side effects inside setter callbacks.
- Clean up listeners, timers, observers, and subscriptions with the owning reactive scope.

## Props And Children

- Do not destructure reactive props when later updates must remain observable.
- Use `splitProps` to separate local props from attributes forwarded to an element.
- Use `mergeProps` or the repository convention when defaults must preserve reactive access.
- Use the `children` helper when children are read repeatedly, inspected, or transformed.
- Compose forwarded event handlers intentionally instead of silently replacing either handler.

## JSX Control Flow

- Use `For` for keyed reactive collections whose items can move, appear, or disappear.
- Use `Index` only when positions remain stable and item values change independently.
- Use `Show`, `Switch`, and `Match` when they make reactive branches and fallback behavior explicit.
- Avoid large inline conditions and collection transformations that hide state ownership inside JSX.

## State

- Keep transient interaction state near the smallest coordinating component.
- Keep server-owned data in the query or resource abstraction used by the repository.
- Create writable drafts only when editing requires divergence from the source value.
- Use stores for structured granular updates and signals for focused values.
- Keep persisted preferences separate from remote server state.

## Components

- Follow existing component, prop, styling, and import conventions.
- Use semantic HTML before adding ARIA roles.
- Keep one exported component in each component file, subject to the private-component exception in `tsx-component-conventions`.
- Forward supported native attributes when building reusable element wrappers.
- Keep context providers focused on one coherent ownership boundary.
- Prefer props and composition for local relationships; use context for shared descendant ownership.
- Keep context values minimal and fail clearly when a required provider is missing.
- Avoid wrappers that add no semantics, layout, behavior, or reusable boundary.

## Ownership And Lifecycle

- Create reactive primitives within the owner responsible for their lifetime.
- Use `onCleanup` for every owned listener, timer, observer, subscription, and imperative resource.
- Use `createRoot` only when intentionally creating a lifetime outside the current owner and expose an explicit disposal path.
- Perform browser-only setup in `onMount` or behind an equivalent environment boundary.

## DOM References

- Use a local reference when the element is read only by event handlers or imperative calls.
- Use a signal when element availability drives reactive measurement or positioning.
- Preserve callback-ref semantics when forwarding a DOM reference.
- Do not mix local and reactive ownership for the same element reference.

## Async Work

- Use the repository query abstraction or `createResource` for reactive asynchronous reads.
- Do not put an asynchronous function directly in `createEffect`.
- Track loading, empty, failure, and stale states explicitly.
- Propagate cancellation where the underlying API supports it.
- Prevent stale asynchronous results from replacing newer state.
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

## High-Frequency Events

- Schedule reactive writes from pointer, scroll, resize, and drag streams at an appropriate frame or time boundary.
- Keep the latest pending input and flush the final value when an interaction ends.
- Use passive listeners only when the handler never prevents the default action.
- Cancel scheduled frames, timers, and listeners when ownership ends.