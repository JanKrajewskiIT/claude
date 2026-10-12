# Tooling Configuration Conventions

## Scope

- Apply this rule when creating, changing, or reviewing linter, formatter, compiler, bundler, Git hook, web server, dependency-automation, or CI configuration.
- Apply it equally to shareable presets and factories that produce such configuration for other repositories.

## Compatibility

- Bound peer ranges to the majors the configuration was verified against and use one range syntax across the manifest.
- Confirm each bundled plugin supports every declared host major through its peer range and through its use of host APIs removed in that major.
- Do not mask plugin incompatibility with package-manager `overrides` or `resolutions`; they apply only to the root project and never reach consumers.
- When a plugin's TypeScript API range differs from the desired compiler range, install the plugin-facing API and compiler under distinct package names. Read supported ranges from current package metadata, verify which package owns each executable, and document the mapping. Do not widen a peer range to hide the conflict.
- Handle option names renamed between supported majors so a consumer value under either name cannot silently replace the preset value.
- Set options whose defaults differ between supported majors explicitly, such as TypeScript `types`.

## Toolchain and Ownership

- Derive local, editor, hook, CI and container toolchains from the same repository-owned runtime and package-manager declarations; keep compatibility files synchronized.
- Separate development toolchain requirements from the runtime requirements of published libraries.
- Keep reusable defaults in the shared configuration package and product-specific choices in the consumer.
- Update canonical agent guidance and regenerate client adapters; do not maintain hand-edited shared instructions in provider directories.
- Keep mutable versions, image digests, advisory exceptions and secret names in executable project configuration or its owning documentation, rather than duplicating them in permanent rules.

## Layering

- Restrict every layer that requires a capability, such as type information, to the files that receive that capability.
- Check that test, script, and configuration globs outside the source directory receive a compatible parser and rule set.
- Turn off a base rule when a plugin rule replaces it, so its options and opt-out patterns apply once.
- Do not restate rules or options that an extended preset already sets to the same value.
- Compose variants through `extends` or a shared base layer instead of re-listing the parent's values.
- Return composable fragments, such as selector lists, from rule builders when consumers may combine several into one rule key.
- Use `warn` only when the consuming pipeline enforces a warning budget; otherwise choose `error` or `off`.
- Preserve a repository's zero-warning budget in normal lint, fix, staged-file and CI commands; do not downgrade findings to make a gate pass.

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
- Validate public build environment values before bundling and derive ambient types, runtime validation and substituted values from one schema. Keep deployment credentials out of client build configuration.

## Hooks

- Prefer project-local tool binaries over global ones so hooks run the locked version.
- Keep stash and partial-staging protection enabled in staged-file tools unless the workflow explicitly accepts committing unstaged changes.
- Evaluate version-manager environment output for the shell that executes it and omit interactive features such as change-directory hooks.

## Web Server

- Define a header set repeated across locations once through an include or snippet.
- Apply long-lived immutable caching only to paths that serve content-hashed file names.
- Emit one `Cache-Control` header per response.
- Keep Content Security Policy relaxations such as `'unsafe-inline'` out of defaults unless a named shipped feature requires them.
- Define the SPA artifact interface explicitly: built files, server configuration, shared includes and required verification metadata. Keep generated output derived from the owning source configuration.

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
- Toolchain declarations agree across consumers and execution environments, or unresolved differences are reported explicitly.
- Public environment inputs have one schema, and generated deployment files have a documented source and artifact contract.
