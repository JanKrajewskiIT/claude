---
name: tooling-config-preset
description: Create, extend, or review shareable tooling configuration presets such as ESLint flat-config factories, Prettier, Stylelint, tsconfig bases, Vite config factories, lint-staged, Git hook helpers, and web server configuration. Use when designing preset layers, factory options and defaults, plugin compatibility across tool majors, or verifying the effective configuration a consumer receives.
---

# Tooling Config Preset

## Goal

- Produce presets whose effective configuration in a consumer matches their documented behavior for every supported tool major.

## When To Use

- Adding or changing a layer, rule, default, or option in a shared tooling preset.
- Raising or widening a supported tool major or a bundled plugin version.
- Reviewing a preset package or a repository that consumes one.

## Do Not Use

- Package exports, declarations, packing, and publishing: use `typescript-library`.
- Application source changes that only consume an existing preset.

## Workflow

1. Inventory consumers and majors.
   - List each tool runtime, its declared peer range, and the consumer layouts it targets, such as application, library, Node tooling, tests, and monorepo packages.
   - Read each bundled plugin's peer range for every declared host major.
   - Search each plugin for host APIs removed in a declared major, such as ESLint 10 rule-context methods.
   - Stop and report when a plugin does not support a declared major; do not mask it with `overrides`.
   - Map dependencies between the preset, libraries and applications, including workflow refs. For coordinated migrations, read [`references/ecosystem-migration.md`](references/ecosystem-migration.md).
2. Map layers to files.
   - Write a table of layer, file globs, and required capability, such as type information, JSX, or environment globals.
   - Confirm each capability-dependent layer matches only files that receive the capability.
   - Trace test, script, and configuration files outside the source directory through every layer.
   - List base rules replaced by plugin rules and disable them.
3. Define the option contract.
   - Accept one options object per factory, or place required arguments first.
   - Derive dependent defaults from their source option.
   - Represent optional features by the presence of their options object.
   - Type finite values as literal unions derived from one runtime set.
   - Validate all inputs at entry through one helper whose errors list allowed values.
   - Remove options that the produced configuration overrides.
4. Implement from one base.
   - Build sibling factories from one shared base and add only their differences.
   - Compose static presets through `extends` and remove values the parent already sets.
   - Use consumer-relative path tokens for path-valued options in shipped files.
   - Set version-sensitive defaults explicitly.
5. Check hooks, server, and CI files against the `tooling-config-conventions` rule when the preset ships them.
   - Trace the runtime/package-manager declarations, editor compiler selection, public environment schema and generated deployment artifact through a library and an application consumer.
   - Use `secure-release-pipeline` when the requested change includes scanner gates, signing or delivery; keep those mechanisms separate from linter/bundler preset design.
6. Verify in consumer fixtures.
   - Ask before running commands unless the current request already approves them.
   - Pack the preset and install the archive into one fixture per targeted consumer layout.
   - Print the effective configuration for representative files with the tool's own command, such as `eslint --print-config`, `tsc --showConfig`, or `stylelint --print-config`.
   - Lint a file importing a CSS Module, a test outside the source directory, a root configuration file, and an `_`-prefixed unused parameter.
   - Build a library fixture with every supported output format and inspect output file names.
   - Validate server configuration with its syntax check and inspect headers for the entry document, a deep route, a hashed asset, and an unhashed public asset.
   - Include missing assets and inspect inherited headers, cache cardinality, compression and configured read-only/non-root runtime behavior.
   - Type-check a fixture that calls every exported factory with representative options.
7. Report.
   - List findings by severity with file and line.
   - Distinguish behavior verified in a fixture from behavior inferred from configuration.
   - State every unrun check with its exact command.

## Constraints

- Do not add or change tests unless the user requests test changes.
- Do not install dependencies or add packages without explicit approval.
- Treat layer order, rule severity, default values, and peer minimums as public contracts.

## Output

- A layer-to-files table, an option contract summary, and a findings or change summary with verification status.

## Completion Criteria

- Every declared host major is supported by every bundled plugin without root-only overrides.
- Every capability-dependent layer applies only to files that receive the capability.
- No option is ineffective, and every dependent default derives from its source option.
- Shipped path options resolve inside the consumer fixture.
- Effective configuration was printed or the exact unrun commands are reported.
- Affected consumers and workflow refs agree with the migration contract, and publication/installation prerequisites are explicit.
