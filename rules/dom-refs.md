---
paths:
  - 'src/**/*.tsx'
---

# DOM Refs

## Default: `let xRef`

`let xRef: HTMLElement | undefined` for refs read inside event handlers, effects, or imperative DOM calls that do NOT drive reactive computations.

## Reactive refs: `createSignal`

`const [xRef, setXRef] = createSignal<HTMLElement | undefined>()` only when the ref must drive reactive code: floating-overlay anchors, measurement effects, `useFloating` middleware that re-runs when the anchor changes.

## Forbidden

- Mixing both styles for refs that play the same role inside one component
- Wrapping a `let xRef` in `createMemo` to make it reactive — convert to `createSignal` instead
- Forwarding `ref` through a prop without typing it as `Ref<HTMLElement>` or returning a setter

## Forwarded refs

When a primitive exposes its own DOM node, accept `ref` in props and assign inline preserving callback-ref semantics:

```tsx
ref={(el) => { props.ref?.(el); internalRef = el; }}
```
