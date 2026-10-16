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

- Declare components, callbacks, event handlers, and local helpers according to the declaration rules in `typescript-conventions`.
- Define stable module constants outside the component when they do not depend on props, state, context, or browser lifecycle.
- Keep render expressions declarative; move substantial branching, mapping, parsing, and event behavior into named values or focused modules.

## Composition

- Give each component one coherent UI or coordination responsibility.
- Split a component when independent state, effects, semantics, or reusable behavior can be owned behind a smaller contract.
- Prefer composition and explicit props over mode flags that combine unrelated component responsibilities.
- Keep props semantic and narrowly typed; do not expose internal implementation details for caller convenience.
- Avoid wrappers that add no semantics, layout, styling target, behavior, or ownership boundary.
- Style the existing semantic element directly when it can own the required layout and presentation.
- Split a component module that exceeds about 250 lines or owns more than one independent state machine; extract each into a sub-component or a hook.
- Replace a child that receives more than about 15 props from one parent with a focused context, a state-owning sub-component, or composition slots; do not pass every label, draft value, and handler through one wrapper.
- Group sibling draft fields, such as create and edit form values, into one store or object instead of one signal per field.
- Do not pre-resolve every translated label in the parent and pass it down as a prop; resolve a label in the component that renders it.

## Design System Composition

- Apply these conventions to applications and libraries that use an existing design system. Build composed views from its components and primitives before reimplementing their semantics, behavior, or presentation.
- Render application text through the project's `Text` and `Heading` components when provided; keep semantic heading levels independent of visual variants. Let library components own the typography of their label, title, and description slots instead of adding redundant text wrappers.
- Let native controls own a distinct control-font role when required; reuse an existing text role when it fits. Syntax fragments, glyphs, and animated decoration may inherit typography from surrounding text.
- Prefer brand foundations, semantic tokens, and supported presentation props, such as text `tone`, before defining local style values or overriding a supplied typography role. Keep component-specific geometry local and add shared tokens only for reusable design decisions.

## Completion Criteria

- Each exported component has one clear responsibility and its own file.
- Private colocated components satisfy the stated exception.
- Shared modules have a neutral responsibility and credible consumers.
- Declarations follow `typescript-conventions`.
- Every rendered wrapper has an observable purpose.
- Components using a design system reuse its primitives, text roles, and semantic tokens rather than recreating them locally.
