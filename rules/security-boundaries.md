---
paths:
  - '**/*'
---

> Type: Rule (normative constraints)
> Source of truth: Rules define mandatory constraints; skills define operational playbooks.

# Security Boundaries

## Trust Model

- The frontend is not the source of truth for authorization
- Backend endpoints must enforce authentication, authorization, and resource access independently of UI state
- Do not rely on hidden buttons or route guards as real protection

## Secrets and Sensitive Data

- Never hardcode secrets, tokens, callback secrets, or private keys in source files
- Do not log access tokens, refresh tokens, passwords, or sensitive personal data
- Keep environment-based secrets in configuration boundaries designed for that purpose

## Data Exposure

- Return only the fields the client actually needs
- Avoid exposing internal identifiers, internal flags, or infrastructure details unless they are part of the product contract
- Treat personally identifiable data with extra care in logs, payloads, and error responses

## Shared Infrastructure Wiring

When the project ships a shared infrastructure library (see `dotnet-shared-infrastructure`):

- At-rest encryption for stored tokens/secrets uses the library's value converter (e.g. `EncryptedStringConverter`) via `.HasConversion(...)`; never store provider tokens or refresh tokens in plaintext columns
- Outbound HTTP from external user input goes through the library's URL-safety validator to block SSRF (internal hosts, private nets, non-HTTPS)
- Service-to-service HTTP forwards the inbound bearer via the library's bearer-forwarding `HttpMessageHandler`; never construct an `HttpClient` to a sibling API without registering it
- Authorization is enforced through named policy constants from the library and roles transformed by the library's claims transformation; never branch on raw claim strings inline
