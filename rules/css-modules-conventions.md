# CSS Modules Conventions

## Scope

- Apply this rule only to projects and files that use CSS Modules.
- Follow established module naming and import conventions before introducing a new style.
- Keep component-local styles beside their owning component when the repository does so.

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