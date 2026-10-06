# Dependency Policy

## Scope

- Apply this rule before adding, upgrading, replacing, or removing an external library, package, or tool dependency.

## Selection

- Reuse platform capabilities and dependencies already owned by the repository before adding another package.
- Compare a proposed dependency's capability, maintenance, security, bundle or runtime cost, transitive dependencies, and compatibility impact with the actual requirement.
- Prefer a small, focused local implementation when the required behavior is simple, stable, testable, and substantially narrower than the proposed library.
- Do not recreate cryptography, authentication protocols, complex parsers, standards-heavy behavior, or other security-sensitive or specialized capabilities with ad hoc code.
- Do not install an external library or add it to a package manifest, project file, dependency declaration, or lockfile without explicit approval in the current request.
- Before requesting approval, explain the required capability, why platform and existing repository options are insufficient, the proposed library, and the material maintenance, security, licensing, runtime, or bundle impact.
- Present the smallest viable local approach and the best-fitting dependency when both are reasonable choices.
- Do not add a library for one trivial helper, formatting operation, collection transformation, or thin wrapper around a platform API.

## Completion Criteria

- No dependency was added to a manifest, project file, or lockfile without explicit approval in the current request.
- Every proposed dependency states its capability, the insufficiency of existing options, and its material impact.
- Security-sensitive or standards-heavy capabilities use established libraries instead of ad hoc code.
