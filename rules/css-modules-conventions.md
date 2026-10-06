# CSS Modules Conventions

## Scope

- Apply this rule only to projects and files that use CSS Modules.
- Follow established module naming and import conventions before introducing a new style.
- Keep component-local styles beside their owning component when the repository does so.
- Use native CSS nesting only when the supported toolchain and browser targets compile or implement it reliably.

## Structure

- Style the owning semantic element directly before adding a wrapper solely as a styling hook.
- Keep nesting shallow and aligned with the rendered component structure.
- Use `&` for states, modifiers, pseudo-classes, and pseudo-elements owned by the current selector.
- Prefer a new local class when nesting would couple styles to incidental DOM depth or element order.
- Keep selectors specific to component-owned classes and attributes instead of tag chains.
- Avoid preprocessors when native CSS expresses the required nesting and composition.
- Use `:global` only for an explicit external boundary that cannot receive a local class; keep the global selector as narrow as possible.
- Prefer container queries when a reusable component should respond to its available space rather than the viewport.
- Use media queries for viewport or device preferences, not to compensate for missing component ownership.
- Keep responsive state in CSS when it changes presentation only; do not duplicate it in component state without a behavioral requirement.

## Tokens and Values

- Use semantic design tokens for shared color, spacing, typography, radius, shadow, and motion decisions.
- Add a token only when the value represents a reusable design decision.
- Pass continuous runtime values through CSS custom properties when CSS owns presentation.
- Use typed classes or attributes for finite semantic variants.
- Keep theme differences behind semantic tokens instead of duplicating component selectors.
- Define a dimension shared by several variants or components, such as control heights, icon sizes, and breakpoints, once as a token or custom property and derive every use from it.
- Use one breakpoint set; do not mix values such as 640, 700, 768, and 960 pixels without a named reason.
- Use `!important` only for user-preference overrides such as reduced motion; never to override another component's styles.
- Use native nesting with `&` for states of the owning selector instead of repeating the full selector for each pseudo-class when the toolchain supports it.

## Ownership

- Keep structural styles required for layout, positioning, stacking, and animation under component ownership.
- Separate structural requirements from replaceable presentation when consumers may restyle a reusable primitive.
- Compose classes through the repository's established utility or syntax.
- Expose narrow class hooks only for stable internal parts that consumers genuinely need to style.

## Safety

- Do not reach into another component with fragile descendant selectors.
- Do not let consumer overrides remove interaction-critical structure.
- Do not leave unused selectors after changing rendered markup.
- Do not duplicate shared token values as unrelated literals.
- Do not introduce global selectors for behavior owned by one component.

## Completion Criteria

- Shared design decisions use semantic tokens, and no shared value is repeated as an unrelated literal.
- Selectors target component-owned classes and attributes; global selectors cover only explicit external boundaries.
- Breakpoints come from one defined set.
- `!important` appears only in user-preference overrides.
- No selector remains unused after a markup change.
