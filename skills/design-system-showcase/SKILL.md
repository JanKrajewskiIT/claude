---
name: design-system-showcase
description: Build a live showcase app for a component library from a design-system showcase template, rendering real components instead of static specimens. Use when one page must present a library's brand, foundations, package ecosystem and every component group while preserving the template's layout and composing its own specimens.
---

# Design System Showcase

## Goal

- Produce a showcase app whose layout follows the given template and whose specimens are the real, live library components.

## When To Use

- A template folder holds the page markup, styles, group list and sample facts.
- The library is installed as a package or readable as source, and the showcase must not link the template at runtime.

## Do Not Use

- Porting the design system itself: use `design-system-solid-port`.
- A new visual direction: use `frontend-design-exploration`.
- One component: use `solidjs-component`.

## Workflow

1. Read the template.
   - List its sections, interactions, group list and facts.
   - Mark what must be preserved (section order, visual structure, behavior) and what is free (specimen arrangement and variants).
2. Settle constraints before coding. Ask when unknown.
   - Source of the library API: installed type declarations or read-only library source.
   - Approval for the verification command set (typecheck, lint, style lint, build), requested once up front.
   - No tests and no package changes unless requested.
3. Bootstrap the project from the repository's tooling presets.
   - Mount the library provider (theme, locale, toasts) at the entry.
   - Render a skip link and a `main` landmark.
4. Build one component per template section with CSS Modules.
   - Derive counts and facts from the registry; drop claims that cannot be verified.
5. Model the library as data.
   - Use `LibraryGroup` (number, slug, kind, `load`) and `Specimen` (id, span, render); a group's `load` returns its specimens through a dynamic `import()`.
   - Derive specimen ids, counts and search matches from the group's message keys so the index, filter and hero facts need no specimen module.
   - Select a group through component state and mirror it in the URL hash with `history.replaceState`; update the selection on `hashchange`, and key group views by stable group objects so typing in search does not remount specimens.
   - Show a polite status message while a group loads and let a failed load reach the app error boundary.
6. Write specimens from verified API only.
   - Build foundation specimens from tokens and component specimens from live components.
   - Put stateful demos in their own component files and keep specimen lists data-only.
   - Use deterministic data relative to today and offline images.
   - Let popups overflow the card frame, contain fixed-position components, and avoid two components registering the same global hotkey.
   - When the showcase is multilingual, keep group titles, blurbs and specimen names and subtitles in one typed dictionary per group (apply `typed-i18n`) and type each specimen list's ids from that dictionary.
7. Delegate groups to subagents with [`references/specimen-brief.md`](references/specimen-brief.md).
   - Assign one to three groups per agent; larger batches are cut off.
   - After each batch list the created files, find missing exports and check that every relative import resolves.
   - Resume a cut-off agent with the exact remaining files.
8. Validate after each batch with the approved commands, fix every finding, and propose a dev-server visual check of grid spans, clipped popups and both themes.

## Constraints

- Do not edit the template or the library.
- Do not invent props, components or icon names.
- Do not copy template markup that depends on its own runtime.
- Do not add dependencies without approval.
- Do not initialize a locale from the browser when the requested default is fixed; read only the persisted choice and fall back to the default.
- Do not assume a library locale switcher is bound to the i18n context; pass its value and change handler.

## Output

- Entry, shell sections, group registry, specimens and demos.
- A list of deviations from the template with reasons and unrun checks with exact commands.

## Completion Criteria

- Every template section exists and every template group has live specimens.
- Verification commands pass or are reported unrun.
- No specimen depends on the network or module-level shared state, and the hash only selects a group.
