# SolidJS Conventions

## Reactivity

- Read reactive values inside the tracked scope that must update.
- Preserve property access on reactive props unless the repository uses a reactive-safe helper.
- Derive values directly or with memos instead of synchronizing writable copies with effects.
- Use effects for external side effects, not pure computation.
- Use explicit effect dependencies when only named sources should trigger work.
- Batch multi-signal updates that represent one atomic transition.
- Compute next values before setters instead of causing side effects inside setter callbacks.
- Clean up listeners, timers, observers, and subscriptions with the owning reactive scope.

## State

- Keep transient interaction state near the smallest coordinating component.
- Keep server-owned data in the query or resource abstraction used by the repository.
- Create writable drafts only when editing requires divergence from the source value.
- Use stores for structured granular updates and signals for focused values.
- Keep persisted preferences separate from remote server state.

## Components

- Follow existing component, prop, styling, and import conventions.
- Use semantic HTML before adding ARIA roles.
- Forward supported native attributes when building reusable element wrappers.
- Keep context providers focused on one coherent ownership boundary.
- Avoid wrappers that add no semantics, layout, behavior, or reusable boundary.

## DOM References

- Use a local reference when the element is read only by event handlers or imperative calls.
- Use a signal when element availability drives reactive measurement or positioning.
- Preserve callback-ref semantics when forwarding a DOM reference.
- Do not mix local and reactive ownership for the same element reference.

## Async Work

- Track loading, empty, failure, and stale states explicitly.
- Propagate cancellation where the underlying API supports it.
- Prevent stale asynchronous results from replacing newer state.
- Keep request mapping and payload normalization outside JSX event markup.

## High-Frequency Events

- Schedule reactive writes from pointer, scroll, resize, and drag streams at an appropriate frame or time boundary.
- Keep the latest pending input and flush the final value when an interaction ends.
- Use passive listeners only when the handler never prevents the default action.
- Cancel scheduled frames, timers, and listeners when ownership ends.