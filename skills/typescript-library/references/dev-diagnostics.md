# Development-Only Diagnostics

## Why Library Builds Lose Them

- Bundlers replace build flags by matching literal expressions such as `import.meta.env.DEV` or `process.env.NODE_ENV`.
- A library build in Vite library mode replaces `import.meta.env.*` with the library's own build mode, so the published file no longer reflects the consumer's mode.
- Assigning `import.meta` or `process.env` to a variable hides the literal expression, so no bundler replaces it and the flag usually reads as `undefined`.

## Preferred Shapes

Publish a `development` export condition when the toolchain can build two variants:

```json
{
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "development": "./dist/dev.js",
      "default": "./dist/index.js"
    }
  }
}
```

Otherwise keep a literal check that consumer bundlers replace:

```ts
const isDevelopment = typeof process !== 'undefined' && process.env.NODE_ENV !== 'production';
```

## Verification

- Search the packed output for the flag expression and confirm it is still the literal the consumer bundler replaces.
- Confirm that a consumer development build emits the diagnostic and a production build removes it.
