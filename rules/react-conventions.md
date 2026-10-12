# React Conventions

## Scope

- Apply this rule only to React components, hooks, and libraries.
- Apply `tsx-component-conventions` for component file, module, declaration, and composition rules.

## Rendering

- Keep rendering pure and derive values during render when they do not require external synchronization.
- Keep state at the smallest component that coordinates all consumers.
- Use controlled or uncontrolled ownership deliberately and do not switch between them during a component lifetime.
- Use stable semantic keys from data; do not use array indexes when items can move, appear, or disappear.
- Preserve state intentionally through component identity and reset it intentionally with structure or keys.

## Hooks

- Call hooks unconditionally at the top level of components and custom hooks.
- Extract a custom hook when reusable behavior coordinates React state, effects, context, or lifecycle.
- Keep pure transformation and domain logic in ordinary modules rather than custom hooks.
- Use effects only to synchronize with systems outside React.
- Include every reactive effect dependency and restructure unstable code instead of suppressing dependency checks.
- Clean up subscriptions, timers, observers, requests, and imperative integrations in the owning effect.
- Do not add `useMemo` or `useCallback` by default; use them when identity is part of a contract or measured work justifies memoization.

## Events And Async Work

- Put user-triggered behavior in event handlers instead of effects.
- Use functional state updates when the next value depends on the previous value.
- Prevent stale asynchronous results from replacing newer state.
- Represent loading, empty, failure, and stale states explicitly.
- Keep request mapping and payload normalization outside JSX event markup.

## Context And Composition

- Keep each context focused on one ownership boundary.
- Split state from actions when consumers need different update frequencies.
- Prefer props and composition for local relationships; use context for genuinely shared descendant ownership.
- Keep provider values stable when identity changes would cause unnecessary consumer work.

## Completion Criteria

- Rendering remains pure and state ownership is explicit.
- Effects synchronize only external systems and clean up owned resources.
- Hook dependencies reflect every reactive input without suppressions.
- Component identity, keys, and async results preserve intended state.
- Memoization exists only for a contract or demonstrated cost.
