---
name: dropdown-keyboard-model
description: Keyboard navigation contract shared by Select, MultiSelect, Autocomplete, DropdownMenu, ContextMenu, CommandPalette, and OptionMenuChip. Use when building or modifying any dropdown surface.
---

> Type: Skill (operational playbook)

Use this playbook for any component with an anchored dropdown surface that supports keyboard navigation.

Normative constraints live in `solidjs-tsx`, `reactivity-performance`, `dom-hygiene`, and `aria-wiring`.

## Required Primitives

- `useDropdownState` — open state + active item index
- `useDropdownPanel` — panel mount/unmount + focus mechanics
- `useFloating` — anchor positioning (with `flip`, `shift`, `offset`, `size`, `matchWidth`)
- `useEscapeKey`, `useClickOutside` — dismissal
- `DropdownSurface` — the surface primitive itself
- Trigger primitives: `DropdownFieldTrigger`, `DropdownInputTrigger`, `DropdownChevronFieldTrigger`, `DropdownTriggerContent`
- `DropdownOption`, `DropdownDivider` for items

## Required Helpers from `~/utils/dropdown.ts`

- `getFocusableDropdownItems(panel)` — collects focusable options
- `handleDropdownArrowNavigation(event, items, currentIndex)` — Up/Down/Home/End/Enter wiring
- `focusDropdownItem(items, index)` — sets focus by index
- `getDropdownOpenTarget(items, mode)` — initial focus target on open
- `createDropdownSurfaceKeyDownHandler(...)` — pre-wired surface keydown

## Required Behavior

- Anchor ref stored as `createSignal<HTMLElement | undefined>()` so floating middleware reacts to mounts (see `dom-refs` rule)
- Panel ref stored as `let panelRef` unless reactive measurements are needed
- Open: focus the first option (or the active one for multi-select)
- Arrow keys cycle through items via `handleDropdownArrowNavigation`
- Escape closes; clicking outside closes; Tab closes and moves focus naturally
- Selection commits via `Enter` and via mouse click; both go through the same handler

## Before Finishing

- Verify keyboard cycling works with disabled items skipped
- Confirm focus returns to the trigger on Escape
- Check that `aria-activedescendant` (or focus, depending on pattern) reflects the active option
- Ensure the surface does not trap focus when `multi-select` keeps the panel open after a click
