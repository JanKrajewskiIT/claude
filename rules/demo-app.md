---
paths:
  - 'demo/**/*.tsx'
  - 'demo/**/*.css'
---

# Demo App Conventions

## Use library components

- Import UI from the library only
- Never create demo-local wrappers that duplicate library behavior
- Exercise real public APIs, not private internals

## Default-first showcases

- Showcase built-in defaults first
- Pass text overrides only when the example is about customization
- When a component owns library copy, let the demo show it in at least one example
- Extracted composites worth keeping get their own showcase sections

## Styling

- Design tokens only
- `demo.css` minimal, focused on layout/composition
- Never recreate library component styling in demo CSS
- No inline styles in demo sections
- Repeating layout patterns → reusable demo utility class

## Structure

- One section component per major category/theme
- Examples realistic, readable, short
- Multiple focused examples over one giant overloaded block

## Component documentation

- New public components get at least one default usage example
- For state variants, showcase only meaningful ones (not every permutation)
- Default API first, customization variants after
- Renamed/deprecated APIs: demo MUST use the current recommended API
