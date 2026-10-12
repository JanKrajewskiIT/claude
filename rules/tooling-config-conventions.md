# Tooling Configuration Conventions

## Scope

- Apply this rule when creating, changing, or reviewing linter, formatter, compiler, bundler, Git hook, web server, dependency-automation, or CI configuration.
- Apply it equally to shareable presets and factories that produce such configuration for other repositories.

## Compatibility

- Bound peer ranges to the majors the configuration was verified against and use one range syntax across the manifest.
- Confirm each bundled plugin supports every declared host major through its peer range and through its use of host APIs removed in that major.
- Do not mask plugin incompatibility with package-manager `overrides` or `resolutions`; they apply only to the root project and never reach consumers.
- When a bundled plugin supports an older compiler major than the one the project wants, keep the plugin-facing package on the supported major and install the newer compiler under another name; for example `typescript-eslint` requires `typescript <6.1`, so use `"typescript": "npm:@typescript/typescript6@^6"` and `"@typescript/native": "npm:typescript@^7"`, then `tsc` runs 7 and `tsc6` runs 6. Do not widen the peer range to hide the conflict.
- Handle option names renamed between supported majors so a consumer value under either name cannot silently replace the preset value.
- Set options whose defaults differ between supported majors explicitly, such as TypeScript `types`.

## Layering

- Restrict every layer that requires a capability, such as type information, to the files that receive that capability.
- Check that test, script, and configuration globs outside the source directory receive a compatible parser and rule set.
- Turn off a base rule when a plugin rule replaces it, so its options and opt-out patterns apply once.
- Do not restate rules or options that an extended preset already sets to the same value.
- Compose variants through `extends` or a shared base layer instead of re-listing the parent's values.
- Return composable fragments, such as selector lists, from rule builders when consumers may combine several into one rule key.
- Use `warn` only when the consuming pipeline enforces a warning budget; otherwise choose `error` or `off`.

## Inputs and Outputs

- Resolve path-valued options in shared configuration files against the consumer, such as TypeScript `${configDir}`, instead of the preset file location.
- Derive output file names from every enabled variant, such as module format, so variants cannot overwrite each other.
- Default security-relevant options to the safe value, such as TLS verification for development proxies, and require an explicit opt-out.
- Accept the syntax a supported dialect requires, such as CSS Modules `composes`, `:global`, `:local`, and `:export`.
- Cover every file extension in staged-file tasks that the matching linter or formatter configuration covers.
- Remove lint selector lists, ignore entries, and allowlists that name components, files, or identifiers that no longer exist, and list each ignore entry once.
- Enforce one file encoding without a byte-order mark and one line-ending policy through the formatter or editor configuration.
- Remove globs, includes, and script references to files that no longer exist, and keep documented verification steps aligned with the scripts that run.
- Set `types` explicitly in a browser-targeted library `tsconfig` so development `@types/*` globals, such as Node timers, do not shape the published types.
- Publish the sources referenced by declaration maps and source maps, or disable the maps.
- Document why a toolchain package is installed under an npm alias and confirm aliased packages do not compete for the same binary name.

## Hooks

- Prefer project-local tool binaries over global ones so hooks run the locked version.
- Keep stash and partial-staging protection enabled in staged-file tools unless the workflow explicitly accepts committing unstaged changes.
- Evaluate version-manager environment output for the shell that executes it and omit interactive features such as change-directory hooks.

## Web Server

- Define a header set repeated across locations once through an include or snippet.
- Apply long-lived immutable caching only to paths that serve content-hashed file names.
- Emit one `Cache-Control` header per response.
- Keep Content Security Policy relaxations such as `'unsafe-inline'` out of defaults unless a named shipped feature requires them.

## CI and Release

- Scope secrets to the step that needs them, not to the job environment.
- Avoid repeating identical verification in a later job or lifecycle script when the verified artifact has not changed.
- Do not run a separate type-check step before a build that performs the same compilation.
- Name secrets after the service they authenticate against, such as an npm registry token rather than a container registry name.
- Confirm the target registry supports provenance and signature verification before enabling or documenting them.
- Use a matrix only when it has more than one entry.
- Give an application one aggregate `verify` script that only composes its existing gate scripts, so one command reproduces the CI gate.

## Completion Criteria

- Every declared host major is supported by every bundled plugin without root-only overrides.
- Every layer that needs a capability applies only to files that have it, and no replaced base rule stays enabled.
- No preset restates inherited values, and every variant composes from a shared base.
- Shipped path options resolve in the consumer, and output names cannot collide.
- Hooks run locked local binaries without committing unstaged changes.
- Repeated server headers have one definition, and immutable caching covers only hashed assets.
- Secrets are step-scoped, and documented release guarantees are supported by the target registry.
- No configuration references a missing file, no verification step runs twice, and published maps resolve to shipped sources.
