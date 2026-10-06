---
name: dotnet-nuget-library
description: Create, evolve, pack, review, or prepare release of a reusable .NET NuGet library. Use when defining target frameworks, package metadata, public API compatibility, dependencies, package contents, symbols, Source Link, versioning, local package consumption, or NuGet publishing.
---

# .NET NuGet Library

## Goal

- Produce an SDK-style package with an intentional public API and predictable consumer behavior.
- Keep package structure independent of one repository architecture.

## Do Not Use

- Use `dotnet-shared-infrastructure` to decide which cross-cutting mechanics multiple services should share.

## Workflow

1. Define consumers.
   - Record supported target frameworks, runtimes, package sources, and compatibility commitments.
   - Prefer the narrowest target matrix that serves actual consumers.
2. Define package ownership.
   - Give each package one coherent capability and public namespace.
   - Prefer one assembly per package unless a documented compatibility need requires another layout.
3. Design the public API.
   - Expose abstractions and domain types intentionally.
   - Keep implementation details and third-party types out of contracts when they create unnecessary coupling.
   - Treat changes to signatures, constraints, inheritance, nullability, and behavior as compatibility decisions.
4. Configure metadata.
   - Set package identity, description, authors, repository metadata, license, and version source.
   - Add README, icon, tags, and release notes when required by the publishing context.
   - Avoid deprecated metadata fields.
   - Use [`references/examples.md`](references/examples.md) for a minimal SDK package shape.
5. Configure dependencies.
   - Declare runtime and compile dependencies accurately.
   - Use private assets only when consumers must not receive those assets transitively.
   - Keep dependency ranges compatible with the repository's version policy.
6. Configure package contents.
   - Include assemblies for each target framework and required runtime assets.
   - Include symbols and Source Link metadata when supported by the distribution model.
   - Exclude secrets, local settings, intermediate output, and unrelated files.
7. Assess version impact.
   - Use the repository's semantic-versioning and compatibility policy.
   - Prefer additive evolution when compatibility must be preserved.
   - Pair deprecation with a usable replacement and removal plan.
   - Classify configuration, dependency, registration, startup, serialization, and behavioral compatibility in addition to source and binary API.
8. Propose package inspection.
   - Propose `dotnet pack` with an isolated output directory.
   - Inspect the `.nupkg`, generated manifest, dependencies, target-framework folders, symbols, and metadata.
   - Ask before running commands unless already approved.
9. Propose consumer validation.
   - Install the exact local package into clean representative consumers.
   - Verify compile-time API, runtime loading, dependency flow, trimming or AOT when supported, and debugging metadata.
   - Use a unique prerelease version to avoid stale global-package cache results.
   - Resolve the exact candidate from a clean package source configuration rather than relying on workspace project references or local build output.
10. Prepare publishing.
   - Confirm immutable version, source, credentials boundary, signing or provenance requirements, and release notes.
   - Publish only the inspected artifact after explicit approval.

## Decision Rules

| Question | Decision |
|---|---|
| Is another assembly independently reusable? | Prefer a separate package dependency. |
| Must consumers compile against a dependency API? | Keep compile assets public. |
| Is a dependency build-only or analyzer-only? | Consider appropriate private assets. |
| Does a change alter observable public API or behavior? | Apply compatibility and versioning policy. |
| Is a package version already published? | Create a new version; packages are immutable. |

## Constraints

- Do not force every library into Application, Domain, and Infrastructure packages.
- Do not assume a successful project build proves package correctness.
- Do not hide required runtime dependencies with private assets.
- Do not overwrite or reuse a published package version.
- Do not publish before inspecting and consuming the packed artifact.

## Completion Criteria

- Target frameworks and package boundaries match real consumers.
- Public API and dependency exposure are intentional.
- Package metadata and contents are complete and free of local artifacts.
- Version impact is documented according to policy.
- Proposed pack and consumer checks validate the exact release artifact.
