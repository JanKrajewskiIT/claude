---
name: secure-release-pipeline
description: Create or review CI pipelines that verify, scan, sign and deliver package archives or container images without changing artifact identity. Use when adding release security gates, SBOMs, signing, artifact transfer or deployment verification; not for ordinary component changes or a live penetration test.
---

# Secure Release Pipeline

## Goal

- Deliver the exact verified artifact through explicit scan, identity and deployment gates, with observable evidence and bounded credentials.

## Workflow

1. Inspect the delivery path.
   - Read the owning build, verification, publication and deployment definitions, manifests and current scanner policies.
   - Trace every applicable PR, branch, tag, manual and scheduled path through job dependencies and artifact transfers.
   - Record the registry, release reference, supported platforms, required service images and existing credentials by role without reading secret values.
2. Establish the requested scope.
   - Distinguish configuration work from authorized execution, publication, deployment and active scanning.
   - Keep existing user instructions about skipped builds or later publication active; report those checks as unrun.
   - Use existing tooling and policies before introducing another scanner or paid service. Check registry/hosting capabilities before selecting an evidence mechanism.
3. Place checks at the owning boundary.
   - Check source secrets, relevant code/infrastructure and dependency inventories before the release path obtains write credentials.
   - Scan final images for runtime vulnerabilities, metadata misconfigurations and embedded secrets before delivery.
   - Preserve separate application and image inventories when bundling removes dependency metadata. Read [`references/control-map.md`](references/control-map.md) to select conditional controls and recognize coverage gaps.
   - Keep severity thresholds and exact expiring exceptions in repository policy. Fail the gate on scanner/database/report failures.
4. Preserve artifact identity.
   - Build and verify once, then upload explicit archives or image/context artifacts with sufficient files for the next job.
   - Validate downloaded artifact identity and reject missing, ambiguous or incomplete release inventories.
   - Repeat relevant checks if a later job changes bytes; do not describe a rebuilt artifact as the one previously verified.
5. Sign and verify the release.
   - Bind the archive or image digest and required SBOM to the approved signer identity.
   - Retain signature bundles/attestations for the release's intended lifetime and document registry-specific limitations and transparency-log exposure.
   - Verify the expected workflow/signer, issuer and source revision before deployment; make the runtime consume immutable image references for every covered service.
6. Bound infrastructure checks.
   - Keep TLS and required health checks strict, and verify proxy routing cannot bypass an introduced WAF.
   - When DAST is requested, constrain targets, redirects and API definition destinations to the authorized environment; separate baseline scans from active scans and authenticated coverage.
   - Distinguish WAF detection from blocking and require representative application behavior evidence before claiming blocking is validated.
7. Validate and report.
   - Check workflow parsing, reusable inputs/secrets, permissions, dependency edges, required artifact contents and immutable executable pins.
   - Run the repository's approved verification/scanning commands only within the authorized scope. Reproduce scanner failure and artifact mismatch behavior when runtime verification is authorized.
   - Document periodic advisory checks, environment prerequisites and the exact checks that remain unrun. Separate configured controls from executed results and findings reviewed by a maintainer.

## Completion Criteria

- Required gates control each applicable release path, and source-scanning jobs do not obtain publication/deployment credentials.
- The artifact and complete image inventory preserve verified identity through publication and deployment.
- The selected signing/SBOM mechanism is supported, retained and verified against the expected identity.
- Scanner failures, exceptions, reports, TLS checks and scan targets preserve their declared boundaries.
- Validation results, unrun checks and required environment setup are explicitly reported without claiming an unexecuted release or security certification.
