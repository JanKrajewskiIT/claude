# TypeScript Library Examples

## ESM Package Exports

```json
{
  "type": "module",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "default": "./dist/index.js"
    },
    "./format": {
      "types": "./dist/format.d.ts",
      "default": "./dist/format.js"
    }
  },
  "files": ["dist"]
}
```

Every public runtime entry has a matching declaration entry. Unlisted internal
paths are not part of the supported API.

## Module Identity

| Runtime output | Explicit declaration option | Interpretation                          |
| -------------- | --------------------------- | --------------------------------------- |
| `.mjs`         | `.d.mts`                    | Explicit ESM                            |
| `.cjs`         | `.d.cts`                    | Explicit CommonJS                       |
| `.js`          | `.d.ts`                     | Determined by the nearest package scope |

For explicit ESM output, use matching entries such as `"types": "./dist/index.d.mts"`
and `"import": "./dist/index.mjs"`. Preserve the emitter's internal declaration
references. Renaming a single declaration does not convert the whole module graph.
A scoped `.d.ts` can also describe ESM when its package declares `type: module`;
check the actual resolution before replacing a valid format.
See the [TypeScript module reference](https://www.typescriptlang.org/docs/handbook/modules/reference.html)
when output formats or consumer resolution modes change.

## Host-Provided Framework

```json
{
  "peerDependencies": {
    "solid-js": ">=1.9 <2"
  },
  "devDependencies": {
    "solid-js": "^1.9.0"
  }
}
```

The peer range describes consumer compatibility. The development dependency
allows the library itself to build and type-check.
