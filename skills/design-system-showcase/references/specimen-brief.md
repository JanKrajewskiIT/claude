# Specimen Brief For Delegated Agents

Give this brief to each agent together with its group assignment. Replace the bracketed parts.

## Task

- Write showcase specimens for [library] in [project path]. Create files; do not run build, test, lint, install or start commands, and do not touch manifests or configuration.
- Finish all assigned groups. Write simpler specimens instead of stopping early.
- Specimens render inside a bordered card in a 12-column grid. The shell renders the card title, so a specimen must not repeat it.

## API Sources

- Working demos of every component: [path].
- Library source with props and documentation comments: [path].
- Design-system reference: [path].
- Trust only verified props, exports and icon names. When unsure, drop the item.
- Import only from the library entry and the framework packages.

## Structure

- A specimen list file per group exports `readonly Specimen<SpecimenIdOf<typeof [group]En>>[]` and contains data only (id, span, render).
- Write the group's title, blurb and each specimen's name and subtitle in `[i18n path]/[group].ts` as English and translated dictionaries keyed by specimen id.
- State, effects and timers go in a demo component file, one exported component per file.
- Keep every file near 250 lines or fewer.
- Styles are CSS Modules beside the owning component.

## Rules

- Use `const` arrow functions, named exports, type-only imports and no `any`.
- Use `Show`, `For`, `Switch` and `Match`, not `&&` or ternaries in JSX; never destructure reactive props; create signals only inside components; clean up timers and listeners.
- Use semantic tokens only; read raw reference tokens only in specimens whose purpose is displaying them.
- Compose classes through the project's typed class helper and callback refs.
- Give every interactive element an accessible name, use native elements first and never convey information by colour alone.
- Write no comments unless a constraint is non-obvious.
- Write English copy in sentence case with no emoji and realistic short data; escape `{`, `}`, `<` and `>` in dictionary messages with a leading apostrophe.

## Report

- List created files, specimen ids per group and every API that was uncertain or skipped.
