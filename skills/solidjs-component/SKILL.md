---
name: solidjs-component
description: Core VelvetUi component patterns for props, file structure, primitives, and shared utilities. Use when creating or modifying library components.
---

Normative constraints: `project-core`, `solidjs-tsx`, `reactivity-performance`, `css-modules`, `i18n`, `demo-app`, `git-standards`.

For specialized work also use:

- `/dom-hygiene-playbook` — wrapper reduction
- `/overlay-patterns` — dialogs, popovers, drawers, focus-trapped surfaces
- `/extract-to-velvetui` — when work starts from app code and may become a library export

## Standard workflow

1. Start from an existing primitive or nearby component before creating a new pattern
2. Create `ComponentName/ComponentName.tsx` and `ComponentName.module.css`
3. Shape the public API around semantics first, then wire styling and variants
4. Export from `src/index.ts`
5. Add a demo example when the component is public

Tests, build, lint, typecheck, verify are NOT part of this workflow — see `rules/project-core.md` "Agent Execution Policy".

## Standard component shape

`import type Props from "~/models/Props"` → semantic interface → `(props: Props<X>) =>` → component export.

- `Props<T>` already covers `class`, `id`, `aria-*`, `data-*`
- `ThemeProvider`, `ToastProvider` may use `ParentProps` (no DOM-like public contracts)

## Design checklist

- Prefer extending existing VelvetUi primitives over wrapper-only components
- One primitive per role in a family
- Render labels/descriptions through shared primitives like `LabelText`
- Reusable visuals stay inside the primitive module; hosts compose, not reskin
- When bringing app code in, extract reusable patterns rather than product-specific workflows
- If the API still needs domain nouns from the source app, it's not ready for VelvetUi yet

## Shared hooks & utilities

Hooks from `~/hooks/`: `useClickOutside`, `useEscapeKey`, `useFocusTrap`, `useOverlayAnimation`.

Utilities from `~/utils/`: `classNames(...)`, `joinAriaIds(...)`, `resolveAriaInvalid(...)`, `resolveAriaErrorMessage(...)`.

## Before finishing

- Re-read matching rules before finalizing API details or copy ownership
- Sanity-check keyboard behavior, accessible naming, ARIA wiring
- Remove wrappers or local styles existing only to patch around a primitive API gap
