---
name: solidjs-component
description: Core VelvetUi component patterns for props, file structure, primitives, and shared utilities. Use when creating or modifying library components.
---

> Type: Skill (operational playbook)
> Source of truth: Rules define mandatory constraints; skills describe execution patterns.

Use this playbook for standard component work. Normative constraints live in `project-core`, `solidjs-tsx`, `reactivity-performance`, `css-modules`, `i18n`, `demo-app`, and `git-standards`.

For specialized work, also use:

- `/dom-hygiene-playbook` for wrapper reduction and DOM cleanup
- `/overlay-patterns` for dialogs, popovers, drawers, and focus-trapped surfaces
- `/extract-to-velvetui` when the work starts from app code and may become a library export

## Standard Workflow

1. Start from an existing primitive or nearby component before creating a new pattern
2. Create `ComponentName/ComponentName.tsx` and `ComponentName.module.css`
3. Shape the public API around semantics first, then wire styling and variants
4. Export the component from `src/index.ts`
5. Add a demo example when the component is public

Tests, build, lint, typecheck, and verify are NOT part of this workflow — see `rules/project-core.md` "Agent Execution Policy".

## Standard Component Shape

`import type Props from "~/models/Props"` -> semantic interface -> `(props: Props<X>) =>` -> component export

- `Props<T>` already covers `class`, `id`, `aria-*`, and `data-*`
- `ThemeProvider` and `ToastProvider` may use `ParentProps` because they do not expose DOM-like public contracts

## Design Checklist

- Prefer extending existing VelvetUi primitives over wrapper-only components
- Keep one primitive per role in a family
- Render labels and descriptions through shared primitives such as `LabelText`
- Keep reusable visuals inside the primitive module; let hosts compose rather than reskin
- When bringing app code into VelvetUi, extract reusable patterns rather than product-specific workflows
- If the API still needs domain nouns from the source app, it is not ready for VelvetUi yet

## Shared Hooks and Utilities

Use shared hooks from `~/hooks/` when applicable:

- `useClickOutside`
- `useEscapeKey`
- `useFocusTrap`
- `useOverlayAnimation`

Use shared utilities from `~/utils/`:

- `classNames(...)`
- `joinAriaIds(...)`
- `resolveAriaInvalid(...)`
- `resolveAriaErrorMessage(...)`

## Before Finishing

- Re-read the matching rules before finalizing API details or copy ownership
- Sanity-check keyboard behavior, accessible naming, and ARIA wiring
- Remove wrappers or local styles that only exist to patch around a primitive API gap
