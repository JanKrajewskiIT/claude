---
name: design-system-solid-port
description: Port a design-system reference (framework components, global CSS, tokens) into a SolidJS and TypeScript component library without redesigning it. Use when translating React or HTML reference components to Solid, bootstrapping a library from a downloaded design system, or filling a library from a reference in dependency order.
---

# Design System To SolidJS Port

## Goal

- Produce Solid components whose DOM, classes, attributes, props and behavior match the reference, styled by the reference CSS unchanged.

## When To Use

- A reference folder holds component sources, type declarations, CSS, tokens and specimens.
- The target is a Solid library that must not import or link the reference at runtime.

## Do Not Use

- Designing new components: use `frontend-design-exploration`.
- Writing one Solid component from scratch: use `solidjs-component`; apply it to each component of the port for reactivity, props and cleanup.
- Dialogs, drawers and popovers whose main challenge is layering: use `accessible-overlays`.
- Menus, listboxes and comboboxes whose main challenge is item interaction: use `accessible-composite-widgets`.
- Verifying an existing port: use `design-system-parity-audit`.
- Localizing defaults: use `component-library-i18n-migration`.
- Tooling configuration and package publishing: use `tooling-config-preset` and `typescript-library`.

## Workflow

1. Inspect the reference.
   - Rank sources: component source, type declarations, specimens, usage notes, reference docs. The higher source wins on conflict.
   - Use [`references/reference-map.md`](references/reference-map.md) to locate each source, the dependency map and the design rules.
   - List components, helpers and types. List out-of-scope parts such as product templates and design-tool bundles.
   - Stop and report if the entry stylesheet imports files that do not exist or component folders are missing. Ask for a complete drop.
2. Settle project constraints before coding. Ask when unknown.
   - Compare the reference's own porting guidance with the project rules and decisions; resolve each conflict in the table of the reference map and record the result.
   - Read the owning project's extension inventory or migration notes, if present. Keep approved integrations and library-owned additions in scope even when absent from the reference; keep demo-only specimens in the demo project.
   - Tests: write none unless requested.
   - Messages: use the project's typed i18n instead of literal defaults.
   - CSS: copy verbatim into the library; never import or link reference code.
   - Granularity: allow splitting into smaller files for reuse; keep one exported component per file.
   - Ownership: preserve explicitly approved infrastructure integrations in dedicated modules and record component relocations independently of reference or showcase groups.
   - Documentation: remove outdated copies instead of keeping two sources.
3. Bring the CSS in.
   - Copy tokens, fonts, component CSS and the entry stylesheet unchanged.
   - Compare file hashes with the reference and require identical results.
   - Put every library addition in separate extension files imported by the package entry. Never edit a copied reference file.
4. Port shared helpers and hooks first.
   - Use [`references/react-to-solid.md`](references/react-to-solid.md) for the translation table and the helper set.
5. Port components in dependency order, not folder order.
   - Check every dependency is done before starting a component.
   - Match classes, `data-*`, `aria-*`, roles, `tabIndex`, key handlers, focus moves, timers and cleanup.
   - Translate the type declarations 1:1, including JSDoc and `@default`, except for recorded project deviations. Rename props only for framework needs or an explicit project decision.
   - Compose other library components. Never copy their markup.
   - Split a part into its own file when it owns state, is reused, or keeps a file readable.
   - Keep each component module near 250 lines or fewer and each child below about 15 props, following the loaded TSX and component-library rules.
6. Replace framework-specific idioms.
   - Replace element cloning with a trigger render function that receives the attributes and handlers to spread.
   - Replace prop injection into children with context.
7. Export and register.
   - Export each component and its types from the folder index and the package index.
8. Validate.
   - Run `design-system-parity-audit` after each group.
   - Update the project's extension inventory when an approved addition, integration or ownership boundary changes.
   - Propose typecheck, lint and build commands and run them only with approval. Use editor diagnostics meanwhile.

## Constraints

- Do not edit the reference folder or any copied reference file.
- Do not add props, variants or tokens, and do not drop or rename props beyond framework needs unless an explicit project decision requires a documented deviation.
- Do not destructure props.
- Do not write inline design values; inline styles carry runtime geometry only.
- Do not port a batch from memory; open the source of the component in hand.

## Output

- Components, helpers, hooks, copied CSS and index exports.
- A short list of deviations from the reference with reasons.

## Completion Criteria

- CSS files are hash-identical to the reference, and library additions live only in extension files.
- Every reference component has a Solid component or a recorded reason for omission.
- Props match the type declarations or a recorded project deviation, and a11y attributes match the sources.
- No import or link points into the reference folder.
- Unrun checks are listed with exact commands.
