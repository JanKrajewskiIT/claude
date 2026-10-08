# Reading A Design-System Reference

Shown with the Velvet drop as the example. Adapt names to the reference at hand.

## Where Things Are

| File or folder | Use |
|---|---|
| `components/<group>/<Name>.jsx` | Markup, classes, behavior, accessibility. Highest authority. |
| `components/<group>/<Name>.d.ts` | Props contract and `@default` values. |
| `components/<group>/*.card.html` | Specimens: how a component must look and what props the demos use. |
| `components/<group>/<Name>.prompt.md` | Usage notes when present. |
| `docs/components.md` | Map of all components: dependency column, CSS file, specimens, section. Use it to plan order and find files, not as a spec. |
| `docs/foundations.md` | Token layers, hard CSS rules, theming, state contract, voice. |
| `docs/composition.md` | Which atom to use for what; container hierarchy. |
| `docs/solid-porting.md`, `docs/AGENTS.md` | The reference's own porting guidance. Read it, then apply the conflict table below. |
| `styles.css`, `tokens/`, `fonts/` | The CSS entry, tokens and fonts. |
| Maintenance notes in the reference | Learn how its docs are kept in sync; resync in the same spirit. |

Ignore product templates, design-tool bundles (flattened stylesheet copies, manifests, thumbnails) and in-browser build artifacts.

Folders organize code. Documentation sections organize the specimen browser. Never regroup code by sections.

## Conflicts Between Reference Guidance And Project Decisions

Settle each item with the owner, apply the decision and record it in project documentation.

| Reference guidance | Typical project decision | Consequence |
|---|---|---|
| Import the reference stylesheet directly. | Copy it into the library and never link reference code. | Compare hashes on every resync. Keep library additions in separate extension files imported by the package entry. |
| One Solid file per reference component file. | One exported component per file, with granular sub-components. | Compare the union of split files with the reference file. |
| Specimen pages and visual and behavior tests. | No tests unless requested. | Verify statically with `design-system-parity-audit`; propose manual checks. |
| Keep reference default strings. | Typed i18n with English and translations. | Localize defaults with `component-library-i18n-migration`; props still override. |
| Track progress in a checklist file. | Record status in project documentation. | One document, no duplicate checklist. |
| Treat reference docs as handoff docs. | Executable sources outrank docs. | Report disagreements between docs and sources. |

## Design Rules To Preserve In Components

- Do not carry design values in inline styles; inline style is for runtime geometry and CSS variables the reference also sets.
- Render icons through the icon primitive only.
- Keep the state contract: default, hover, focus-visible, active, selected, disabled, loading, invalid, driven by classes and attributes.
- Keep shared keyframes and tokens where the reference defines them.
- Compose atoms instead of redeclaring surface, border and typography.
- Keep copy conventions: sentence case, verb plus object, no emoji.

## Order Of Work

Order by the dependency column, not by folder. A typical default among ready components is primitives, actions, forms, display, feedback, navigation, menus, data, charts, media, layout, patterns. Start with the icon primitive, spinner, surface, field, control, option and button.

## Resync

1. Replace the reference folder in its own commit.
2. Diff it against the previous commit.
3. Copy changed CSS, tokens and fonts, then compare hashes.
4. Apply changed component sources and declarations to the matching Solid files.
5. Port new components in dependency order; remove deleted ones with their exports, demos and dictionary keys.
6. Rerun `design-system-parity-audit` for the touched groups.
