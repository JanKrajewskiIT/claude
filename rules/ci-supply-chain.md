# CI Supply Chain

## Scope

- Apply when creating, changing or reviewing CI verification, artifact transfer, package publication, image delivery or deployment configuration.
- Preserve the requested task scope; this rule does not authorize publishing, deployment, scans or new service integrations.

## Execution Boundaries

- Pin external workflow actions to reviewed immutable commits and runtime images to reviewed digests; keep update automation and human-readable version context.
- Pin downloaded scanner/signing binaries by version and verify a repository-owned checksum or signature before execution. Do not fetch an unreviewed latest executable.
- Give jobs the least required permissions, keep publication/deployment credentials out of source-scanning jobs, and avoid persisting checkout credentials unless a documented operation needs them.
- Keep credentials step-scoped and distinguish read-only source/package access from release and deployment access.
- Pass untrusted event values as validated data or environment variables, rather than interpolating them into executable shell source.
- Require security gates on every applicable release path. Do not make required scans optional through success fallbacks, unconditional publication or broad error suppression.

## Artifact Identity

- Verify once, transfer that artifact, and publish or deploy the same bytes. If a later job rebuilds or mutates it, repeat the relevant verification.
- Check artifact identity against the expected package name/version, source revision and release reference as applicable; fail on missing or ambiguous artifacts.
- Preserve separate dependency inventories for the application and final image when bundling removes package metadata; an OS image scan does not prove the frontend dependency tree was checked.
- Bind signatures and attestations to immutable artifact digests and retain the evidence for the release's intended lifetime.
- Verify signatures before deployment against the expected signer/workflow identity, issuer and source revision, rather than accepting any valid signature.
- Make the deployment configuration consume the verified digest, not a mutable tag; require a complete, unambiguous image inventory for the services covered by the gate.

## Infrastructure and Claims

- Confirm registry and hosting-plan capabilities before requiring provenance, native attestations or security dashboards; do not assume one registry's features apply to another.
- Keep health and transport checks strict: missing required services, invalid TLS and signature failures must not become a successful deployment.
- Preserve private upstream routing when adding a WAF; remove host-port or proxy routes that bypass the intended path.
- Treat a WAF detection policy separately from a validated blocking policy, and keep active application scans inside their approved test environment.
- Recheck released dependencies and deployed image inventories against current advisory databases without rebuilding releases merely to scan them.

## Completion Criteria

- Executable dependencies are pinned and verified; credential and event-data boundaries are explicit.
- The applicable security and identity gates control the release path.
- Published/deployed artifacts match the verified bytes and digests, and required image identities are complete.
- The target registry supports the chosen evidence mechanism and retained signatures are verified before deployment.
- Infrastructure checks preserve TLS and WAF routing boundaries.
- Configured controls, executed checks, unavailable checks and remaining environment setup are reported separately.
