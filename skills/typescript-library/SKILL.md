---
name: typescript-library
description: Create, configure, build, review, or publish a TypeScript library package with stable exports and usable declarations. Use when working on package.json exports, ESM or CommonJS output, declaration files, peer dependencies, package contents, compatibility, or npm package verification.
---

# TypeScript Library

## Goal

- Produce a package whose runtime files, type declarations, and public API agree.
- Preserve compatibility intentionally across supported runtimes and consumers.

## Workflow

1. Define consumers and compatibility.
   - Record supported runtimes, module systems, TypeScript range, bundlers, and package manager.
   - Inspect existing package and workspace conventions before selecting tools.
2. Define the public API.
   - List the root entry point and intentional subpath exports.
   - Treat a new `exports` map or removed subpath as a compatibility decision.
   - Keep internal modules unreachable through documented package imports.
   - Keep internal helpers out of the root entry point; every export is a compatibility commitment.
3. Configure module output.
   - Declare the package module format explicitly with `type` or file extensions.
   - Add dual ESM and CommonJS output only when consumers require both.
   - Order conditional exports from specific conditions to the fallback.
   - Use [`references/examples.md`](references/examples.md) for export and dependency shapes.
4. Configure declarations.
   - Generate declarations from source when practical.
   - Map every public runtime entry point to its public types.
   - Keep declarations required by consumers in published dependencies.
   - Export every type reachable from a public signature; check the declaration surface for types consumers cannot name.
   - Ship the sources referenced by declaration maps and source maps, or disable the maps.
   - Set the compiler `types` list explicitly so development-only globals do not leak into published declarations.
5. Classify dependencies.
   - Use `dependencies` for runtime requirements owned by the package.
   - Use `peerDependencies` for host-provided frameworks or single-instance integrations.
   - Bound peer ranges to the tested major versions instead of open-ended `>=` ranges.
   - Use `devDependencies` only for development and build tooling.
   - Keep development toolchain versions out of `engines`; declare only consumer runtime requirements there.
6. Control package contents.
   - Include runtime output, declarations, metadata, license, and required assets.
   - Exclude source secrets, tests, caches, local configuration, and unrelated artifacts.
7. Build and inspect the package.
   - Use the repository's package manager and build pipeline.
   - Ask before running commands unless the current request already grants permission.
   - Create a local package archive and inspect its exact file list and manifest.
   - Inspect the built output for development-only branches and confirm they still depend on a flag the consumer toolchain resolves.
   - Use [`references/dev-diagnostics.md`](references/dev-diagnostics.md) when the library emits development-only warnings.
8. Test consumer behavior.
   - Install the archive into a clean fixture.
   - Test supported import styles, subpaths, types, and runtime environments.
   - Run available package contract tools such as `publint` or Are The Types Wrong.
   - Report missing behavior tests for parsers, formatters, and public functions as a release risk.
   - Report documentation or configuration that claims verification, such as contract tests, that the scripts no longer run.
9. Prepare release.
   - Classify public API changes using the repository's versioning policy.
   - Verify package name, version, registry, provenance, access, and release tag.
   - Confirm the target registry supports provenance and signature verification before requiring them.
   - Add a changelog entry for every published version.
   - Publish only after the packed artifact and consumer checks pass.

## Decision Rules

| Question                                       | Decision                               |
| ---------------------------------------------- | -------------------------------------- |
| Do consumers need one module format?           | Publish one explicit format.           |
| Do consumers require ESM and CommonJS?         | Use conditional exports and test both. |
| Is a framework supplied by the host app?       | Prefer a peer dependency.              |
| Is a subpath not part of the public contract?  | Do not export it.                      |
| Does adding `exports` hide prior import paths? | Treat it as potentially breaking.      |

## Constraints

- Do not infer package correctness from a successful source build alone.
- Do not publish declarations that reference unavailable private or development types.
- Do not expose build directories accidentally through broad export patterns.
- Do not publish from an uninspected working tree or an unverified archive.
- Do not alias `import.meta`, `import.meta.env`, or `process.env` before reading build flags; bundlers replace only literal expressions.
- Do not reimplement a specialized capability, such as a query cache, router, or schema validator, when a maintained library covers the requirement; record the reason when a local implementation is chosen.

## Completion Criteria

- Runtime format, exports, declarations, and dependency classes agree.
- The package archive contains only intentional files.
- A clean consumer resolves every supported entry point at runtime and type-check time.
- Package contract checks pass, documented compatibility exceptions are explicit, or the checks are reported as unrun with exact commands.
- Versioning reflects the observable public API change.
- Development-only diagnostics fire in consumer development builds and disappear from production builds.
- The changelog documents every published version.
