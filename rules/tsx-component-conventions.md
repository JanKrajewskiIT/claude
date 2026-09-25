# TSX Component Conventions

## Scope

- Apply this rule to component modules written in TSX or JSX.
- Apply the matching framework rule for lifecycle, reactivity, state, and effects.
- Follow established project structure when it is stricter or required by public compatibility.

## Component Files

- Keep one exported component in each component file.
- Name the file after its exported component according to repository conventions.
- Keep a small private component in the same file only when it has no independent responsibility, reuse potential, or reason to test or style separately.
- Move a private component to its own file when it gains state, substantial behavior, a distinct semantic role, or independent reuse.
- Keep types, constants, styles, and focused helpers beside their owner when they serve only that component.

## Module Boundaries

- Extract behavior, types, constants, or styling foundations when at least two credible components can use them through a neutral API.
- Prefer focused modules named for their responsibility over generic `utils`, `helpers`, or `common` collections.
- Keep product-specific behavior with its owning feature even when its implementation looks technically reusable.
- Keep shared modules independent of individual component markup and private state.
- Avoid barrel files unless they define an intentional public module boundary.

## Declarations

- Declare components, callbacks, event handlers, and local helpers with `const` arrow functions by default.
- Use a function declaration when hoisting, overloads, recursion, framework requirements, or an established public API make it clearer.
- Define stable module constants outside the component when they do not depend on props, state, context, or browser lifecycle.
- Keep render expressions declarative; move substantial branching, mapping, parsing, and event behavior into named values or focused modules.

## Composition

- Give each component one coherent UI or coordination responsibility.
- Split a component when independent state, effects, semantics, or reusable behavior can be owned behind a smaller contract.
- Prefer composition and explicit props over mode flags that combine unrelated component responsibilities.
- Keep props semantic and narrowly typed; do not expose internal implementation details for caller convenience.
- Avoid wrappers that add no semantics, layout, styling target, behavior, or ownership boundary.
- Style the existing semantic element directly when it can own the required layout and presentation.

## Completion Criteria

- Each exported component has one clear responsibility and its own file.
- Private colocated components satisfy the stated exception.
- Shared modules have a neutral responsibility and credible consumers.
- Declarations follow the `const` default unless a documented language or framework reason applies.
- Every rendered wrapper has an observable purpose.