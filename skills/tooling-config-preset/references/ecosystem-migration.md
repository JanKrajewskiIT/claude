# Coordinated Preset Migration

Read this when one shared preset change affects multiple libraries, applications
or reusable CI workflows.

## Inventory and Ownership

- Map the preset, peer dependencies, downstream libraries, applications and workflow references from executable manifests.
- Separate reusable mechanics from consumer-owned product values such as API/auth origins, public assets and CSP allowances.
- Derive runtime, package-manager and editor selections from the repository's declarations; verify the compiler/API aliases and binary owners without copying a fixed version into permanent guidance.
- Keep generated editor/server files derived from their templates and source configuration. Preserve project-owned editor settings and agent client permissions when synchronizing tooling.

## Contract Changes

- Record exported preset paths, supported tool majors, declaration module formats, peer minimums and generated artifact layout.
- Trace a generated SPA context from build output through its image recipe and verifier; include every script, include file and metadata value needed in a fresh CI job.
- Preserve consumer runtime `engines` separately from development-only toolchain requirements.
- Inspect all reusable workflow inputs, secrets, permissions, `needs` edges, uploaded files and artifact names after edits.
- Use the owning manifest as the version source; do not bump a coordinated unpublished release merely because work continued unless the versioning contract or user requests it.

## Verification and Handoff

- Check one library consumer and one application consumer when they use different presets. Include root configuration modules and emitted declarations rather than checking only `src/`.
- Reuse project-local tools and the aggregate verification command. If the user reserves installs/builds for later, perform only authorized checks and list the remaining commands and prerequisites.
- Treat 'assume the packages are available' as permission to prepare consumer references, not evidence that publication or a clean install succeeded.
- Publish the shared preset and its workflow reference before libraries that require it, then publish dependent libraries in dependency order and refresh applications.
- For an unpublished workflow release, prepare a versioned ref and document the final immutable-commit pin once that commit exists; never invent a SHA or silently use a moving default branch.
- Summarize exact release/installation order, artifact changes and remaining runtime checks in the project's owning documentation. Keep versions, credentials, digests and advisory exceptions there, outside generic skill instructions.
