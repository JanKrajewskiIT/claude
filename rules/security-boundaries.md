# Security Boundaries

## Trust

- Treat every external input as untrusted until validated at its owning boundary.
- Enforce authentication, authorization, and resource ownership on the server.
- Do not treat hidden UI, route guards, or client validation as authorization.
- Return only data the caller is authorized to receive.

## Secrets

- Keep secrets, tokens, private keys, and production credentials out of source control.
- Do not request, print, store, or include secrets in agent context.
- Do not read secret-bearing files unless the user explicitly authorizes the exact need.
- Redact credentials, personal data, and sensitive payloads from logs and errors.
- Use the repository's approved secret provider and rotation mechanism.

## Data

- Collect, persist, expose, and log only data required by the feature.
- Treat authorization failures as non-disclosing responses.
- Protect tenant and resource boundaries in every query and mutation.
- Keep internal identifiers and infrastructure details private unless they are contract fields.

## Integrations

- Scope credentials to the intended service and operation.
- Validate user-controlled outbound destinations against SSRF and unsafe-scheme risks.
- Use parameterized APIs for database, shell, URL, and structured-data boundaries.
- Verify signatures, issuers, audiences, expiry, and replay protection where applicable.

## Changes

- Preserve existing security controls unless the user explicitly requests a reviewed replacement.
- Require confirmation before weakening access, validation, encryption, or audit behavior.
- Report unresolved security assumptions instead of inventing permissive defaults.