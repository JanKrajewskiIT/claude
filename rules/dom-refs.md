---
paths:
  - 'src/**/*.tsx'
---

> Type: Rule (normative constraints)

# DOM Refs

## Default: `let xRef`

Use a plain `let xRef: HTMLElement | undefined` for refs that are read inside event handlers, effects, or imperative DOM calls but do not need to drive reactive computations.

## Reactive Refs: `createSignal`

Use `const [xRef, setXRef] = createSignal<HTMLElement | undefined>()` only when the ref must drive reactive code: floating-overlay anchors, measurement effects, or `useFloating` middleware that re-runs when the anchor changes.

## Forbidden

- Mixing both styles for refs that play the same role inside one component
- Wrapping a `let xRef` in a `createMemo` to make it reactive — convert to `createSignal` instead
- Forwarding `ref` through a prop without typing it as `Ref<HTMLElement>` or returning a setter

## Forwarded Refs

When a primitive needs to expose its own DOM node, accept `ref` as part of its props and assign it inline (`ref={(el) => { props.ref?.(el); internalRef = el; }}`), preserving callback-ref semantics.
