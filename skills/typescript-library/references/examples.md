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
