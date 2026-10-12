# Release Control Selection

Use this reference to select checks for the actual delivery path. Do not add every
control to a repository that has no matching artifact or execution environment.

| Boundary                   | Required evidence for the configured gate                                                       | Coverage limit                                                          |
| -------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Source history or PR range | Redacted secret scan; relevant SAST and workflow/IaC findings                                   | A clean scan does not prove authorization or business correctness       |
| Dependency graph           | Lockfile/restore-based audit and application SBOM, including declared build-time coverage       | A final SPA image may contain no package inventory                      |
| Built image                | Final image vulnerability/secret checks; configured metadata checks; image SBOM                 | Source Dockerfile checks alone do not inspect the built image           |
| Archive/image transfer     | Exact identity, expected file count/layout, revision/version and immutable image inventory      | Uploading files does not prove they were checked                        |
| Release signing            | Supported signature/bundle/attestation linked to the artifact digest                            | A signature proves identity/integrity, not absence of vulnerabilities   |
| Deployment                 | Expected signer/workflow, issuer and revision; immutable runtime references; valid TLS/health   | Verifying a digest is ineffective if Compose still starts a mutable tag |
| Running application        | Explicit target scope, baseline or active policy, authentication coverage and bounded test data | A baseline scan or WAF sample payload is not a penetration test         |
| Published release          | Periodic checks using current advisory databases and retained evidence                          | An immutable base-image digest does not remain vulnerability-free       |

Read current executable configuration for scanner versions, binary checksums,
container digests, severity thresholds, exception expiry, report retention and
credential names. Reuse the repository's mechanisms rather than prescribing a
particular vendor or a copied historical version.

For GitHub Actions, review the [secure use reference](https://docs.github.com/en/actions/reference/security/secure-use)
when permissions, events, actions or artifact trust boundaries change. For npm,
check [registry-specific provenance prerequisites](https://docs.npmjs.com/generating-provenance-statements/)
before enabling that option. For Cosign, inspect [identity and artifact verification](https://docs.sigstore.dev/cosign/verifying/verify/)
when configuring signer claims or deployment enforcement.

Document private-registry access, plan-dependent features and public transparency
log metadata before release. Keep repository settings and staging/production
configuration as explicit handoff requirements when they are outside the authorized
code-editing task.
