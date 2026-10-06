# Tooling Configuration Conventions

## Scope

- Apply this rule when creating, changing, or reviewing linter, formatter, compiler, bundler, Git hook, web server, dependency-automation, or CI configuration.
- Apply it equally to shareable presets and factories that produce such configuration for other repositories.

## Compatibility

- Bound peer ranges to the majors the configuration was verified against and use one range syntax across the manifest.
- Confirm each bundled plugin supports every declared host major through its peer range and through its use of host APIs removed in that major.
- Do not mask plugin incompatibility with package-manager `overrides` or `resolutions`; they apply only to the root project and never reach consumers.
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
- Confirm the target registry supports provenance and signature verification before enabling or documenting them.
- Use a matrix only when it has more than one entry.

## Completion Criteria

- Every declared host major is supported by every bundled plugin without root-only overrides.
- Every layer that needs a capability applies only to files that have it, and no replaced base rule stays enabled.
- No preset restates inherited values, and every variant composes from a shared base.
- Shipped path options resolve in the consumer, and output names cannot collide.
- Hooks run locked local binaries without committing unstaged changes.
- Repeated server headers have one definition, and immutable caching covers only hashed assets.
- Secrets are step-scoped, and documented release guarantees are supported by the target registry.
