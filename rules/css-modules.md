---
paths:
  - 'src/**/*.module.css'
---

# CSS Modules

- camelCase classes only
- Use design tokens from `src/theme/globals.css`
- Never hardcode colors, spacing, radius, or shadows
- Do not use `composes`
- Reuse shared styles by importing modules in TSX and combining with `classNames()`
- Prefer `ComponentName.tsx` + `ComponentName.module.css` pairs
- Shared standalone style modules only when truly reused across multiple primitives
- Dark theme flows through semantic tokens, never `[data-theme="dark"]` targeting

## Neutral primitive styling

- Base primitives stay visually neutral by default
- No gradients, glow, spotlight, hover lift, scale, or translate motion in default primitive styles
- `Card` is a baseline surface, not attention-seeking
- For hover elevation or promotional emphasis, create an opt-in variant or separate component
- Parents may position primitives but must not reskin their core visuals from host CSS

## CSS custom properties for dynamic values

- JS-driven values pass as custom properties: `style={{ "--my-var": value }}`
- Consume with `var(--my-var, <fallback>)` in CSS
- Prefer this over inline CSS when CSS can own the styling
- Fixed discrete variants use classes, not runtime custom properties
