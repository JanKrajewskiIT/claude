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
- Do not treat query-string redaction or a JWT-shaped pattern as complete secret sanitization; account for structured fields, bearer credentials, and opaque tokens before exposing dependency error text.
- Use the repository's approved secret provider and rotation mechanism.

## Data

- Collect, persist, expose, and log only data required by the feature.
- Sanitize or encode untrusted values with the repository-approved logging boundary before interpolation; parameterized logging alone does not remove control characters used for log forging.
- Treat authorization failures as non-disclosing responses.
- Protect tenant and resource boundaries in every query and mutation.
- Keep internal identifiers and infrastructure details private unless they are contract fields.
- Do not render raw exception messages in user interfaces or error fallbacks; show a localized generic message with a recovery action and send diagnostics through a sanitized logging boundary.
- Treat HTML from rich-text editors, Markdown, and consumers as untrusted; sanitize it with an established sanitizer before assigning it to `innerHTML` or rendering it as raw HTML.
- Do not build a feature on a deprecated platform API, such as `document.execCommand`, without a documented replacement path.

## Integrations

- Scope credentials to the intended service and operation.
- Validate user-controlled outbound destinations against SSRF and unsafe-scheme risks.
- Use parameterized APIs for database, shell, URL, and structured-data boundaries.
- Verify signatures, issuers, audiences, expiry, and replay protection where applicable.

## Changes

- Preserve existing security controls unless the user explicitly requests a reviewed replacement.
- Require confirmation before weakening access, validation, encryption, or audit behavior.
- Report unresolved security assumptions instead of inventing permissive defaults.
