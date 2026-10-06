# Component Library Conventions

## Scope

- Apply this rule to reusable UI component libraries, in addition to `tsx-component-conventions` and the matching framework rule.

## Consistency

- Use one export style for every component, hook, provider, and utility in the library, and make the public entry point re-export in that style.
- Declare components, hooks, and utilities according to the declaration rules in `typescript-conventions`.
- Declare each exported prop type under its public name, `<Component>Props`; do not rename it in an export clause.
- Use one result shape for sibling hooks, one status vocabulary, and one absence sentinel across the library.
- Give shared prop helpers names that state their role; do not export a generic `Props` default for library-wide use.

## Public Contract

- Type native-attribute pass-through with one documented base shape and keep it identical across sibling components, such as every button-like or input-like component.
- Do not expose module-level mutable state, such as shared signals or timer maps, from the public entry point; expose a provider and a hook.
- Expose one prop for one concept; do not accept both `children` and `label` for the same content unless a typed union enforces exactly one.
- Keep each documented default, such as page size, delay, and duration, in one named constant shared by the component and its documentation.

## Localization

- Keep every user-visible string, including default day names, month names, and placeholders, in the localization dictionary or an injected prop; never in a component or utility constant.
- Format dates, numbers, and lists with `Intl` and the active locale, not fixed English abbreviations.

## Verification

- Keep lint selector lists, forbidden-prop lists, and documentation inventories synchronized with the components that exist.
- Treat a component library without automated interaction tests as unverified for keyboard, focus, and controlled/uncontrolled behavior; report the gap and ask before adding tests.

## Completion Criteria

- One export, declaration, and prop-naming style holds across the library.
- No user-visible literal remains outside the localization boundary.
- No public module-level mutable state remains.
- Lint and documentation inventories name only existing components.
