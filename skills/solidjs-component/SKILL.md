---
name: solidjs-component
description: Create, refactor, or review accessible SolidJS components with correct fine-grained reactivity, typed props, composition, events, styling, and cleanup. Use when the primary outcome is implementing a Solid component, component-library primitive, or reusable TSX behavior after any required design direction is established.
---

# SolidJS Component

## Goal

- Build a small, accessible component with predictable reactive behavior.
- Preserve the component library and styling conventions of the repository.

## Workflow

1. Find the nearest component pattern.
   - If the user requests a new, alternative, independent, or from-scratch design, apply `frontend-design-exploration` before inspecting existing UI implementations or solution documentation.
   - Otherwise, reuse existing fundamentals, primitives, patterns, and documentation before creating another implementation.
   - Inspect public props, exports, styling, tests, stories, and accessibility helpers.
   - Extend an existing primitive when it already owns the behavior.
2. Define the semantic contract.
   - Specify controlled and uncontrolled state, events, slots, defaults, and forwarded element props.
   - Prefer semantic props over presentation-specific switches.
3. Preserve reactivity.
   - Read reactive props inside tracked expressions.
   - Use `splitProps` when separating local and forwarded props.
   - Use `mergeProps` or the repository convention for reactive defaults.
   - Do not destructure or eagerly copy props when updates must remain reactive.
   - Use [`references/examples.md`](references/examples.md) for reactive props and cleanup patterns.
4. Implement the structure.
   - Use semantic HTML before adding ARIA roles.
   - Keep DOM depth proportional to layout and interaction needs.
   - Forward supported attributes and compose event handlers intentionally.
   - Preserve callback behavior when forwarding DOM refs.
   - Use context for compound parts that require one parent-owned state boundary.
   - Keep compound context values minimal and fail clearly when a required provider is missing.
5. Implement state and effects.
   - Derive values instead of synchronizing duplicate state.
   - Use effects for external side effects, not routine derivation.
   - Register cleanup for listeners, timers, observers, and imperative integrations.
   - Split a component that exceeds about 250 lines or owns several state machines by following [`references/splitting.md`](references/splitting.md).
6. Implement interaction and accessibility.
   - Support the keyboard model expected for the component role.
   - Preserve focus, accessible naming, disabled semantics, and error relationships.
7. Style the component.
   - Reuse design tokens and local styling conventions.
   - Keep variants finite, typed, and meaningful to consumers.
8. Export and validate.
   - Update only intended public entry points.
   - Propose focused type checking, tests, linting, and build checks available in the repository.
   - Ask before running commands unless the current request already grants permission.
   - Verify keyboard, focus, reactive prop updates, and forwarded attributes.

## Decision Rules

| Situation                                        | Decision                                                         |
| ------------------------------------------------ | ---------------------------------------------------------------- |
| Value can be calculated from reactive input      | Derive it; do not mirror it in a signal.                         |
| Props must be divided and forwarded              | Use `splitProps`.                                                |
| Defaults must preserve reactive access           | Use `mergeProps` or the established equivalent.                  |
| Behavior is shared without visual structure      | Prefer a primitive or hook.                                      |
| Compound parts share parent-owned behavior       | Use one focused context instead of prop drilling.                |
| Several parts of one large component share state | Compose hooks into one controller object owned by the component. |
| Component requires product-specific nouns        | Keep it in the product until a neutral API exists.               |

## Constraints

- Do not apply React lifecycle or rerender assumptions to SolidJS.
- Do not mutate props.
- Do not add ARIA that conflicts with native semantics.
- Do not expand the public API to compensate for one caller without checking reuse.

## Completion Criteria

- Reactive inputs continue updating after component initialization.
- Public props express behavior and semantics with stable types.
- Keyboard, focus, labeling, and disabled behavior match the component role.
- Resources are cleaned up and forwarded props behave intentionally.
- Public exports are intentional, and focused validation passes or is reported as unrun with exact commands.
