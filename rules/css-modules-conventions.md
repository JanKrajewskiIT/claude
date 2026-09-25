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