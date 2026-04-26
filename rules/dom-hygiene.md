---
paths:
  - 'src/**/*.tsx'
---

# DOM Hygiene

Keep the rendered tree shallow. Every `div`, `span`, `Fragment`, or `<Show>` must justify itself with semantics, state, or layout that cannot move onto the child.

## No wrapper-only nodes

- No `div`/`span` whose sole purpose is to carry a class for a single child — move the class onto the child
- No wrapper just to hold a `style={{ ... }}` for a single child — pass the style or a CSS custom property to the child
- No wrapper for a trivial gap/flex row when the parent already controls the layout
- Drop the wrapper's CSS rule when the wrapper is removed; never leave orphaned classes
- When deleting a wrapper, transfer every meaningful style (`display`, `gap`, `flex-*`) onto the child's merged class list

## Primitive class merging

- Prefer primitives with style-extension props (`class`, `contentClass`, `frontClass`, `backClass`, `containerClass`) over wrapping in a host `div`
- When consumers repeatedly need to style an internal part, add a dedicated `*Class` prop to the primitive instead of growing an external wrapper
- New `*Class` props merge with internal defaults via `classNames()`, never replace silently
- Class extension props are opt-in and additive; default appearance unchanged

## Semantic elements via `as` / `role`

- Don't wrap a primitive in `article`/`section`/`nav` for semantics — pass `as="article"` and put `draggable`/`role`/`aria-*` on the primitive
- Don't add an outer wrapper just to carry `role="search"` etc. when the rendered child is the correct role holder
- Shared primitive APIs accept the semantic props they need (`as`, `role`, `draggable`, `aria-*`)

## Structural vs presentational CSS in primitives

Primitives using absolute positioning, flip/translate animations, or stacking contexts MUST split their CSS:

- Structural layer (positioning, `transform`, `backface-visibility`, size constraints): unconditional
- Presentational defaults (background, border, radius, shadow, padding): separate default class, applied only when no consumer-provided class is passed

This lets consumers pass `frontClass`/`backClass` to restyle faces without breaking animations. Hosts can override only presentational layers, never structural.

## Conditional rendering

- Don't wrap `<Dialog>` (or anything managing its own `showModal()`/`close()`) in `<Show when={open}>` — gate via the component's `open` prop
- Use `<Show fallback={...}>` to avoid an otherwise-useless wrapper when optional parts (label, description, icon) are absent
- When conditional branches produce the same child with different wrappers, factor the child into a local variable and switch the wrapper via `<Show fallback={...}>`
- Reserve outer `<Show>` gates around heavy children only when the goal is genuine unmount (e.g. virtualized tree)

## Acceptable wrappers

Wrappers are allowed when they provide at least one of:

- Real semantics not expressible by the child (landmark role, form grouping, list container)
- Layout composing more than one child (flex row/column, grid container)
- State-bearing or focus-management behavior (focus traps, scroll containers, intersection roots)
- A reusable primitive contract (`Field`, `Card`, `LabelText`, etc. that owns its own styles and state)

If none of the above applies, the wrapper is redundant.
