---
paths:
  - '**/*'
---

# Security Boundaries

## Trust model

- Frontend is NOT the source of truth for authorization
- Backend endpoints enforce authentication, authorization, resource access independently of UI state
- Hidden buttons and route guards are not real protection

## Secrets

- Never hardcode secrets, tokens, callback secrets, private keys
- Do not log access tokens, refresh tokens, passwords, sensitive personal data
- Keep environment-based secrets in proper configuration boundaries

## Agent read boundaries

Every repository SHOULD ship `.claude/settings.json` with a `permissions.deny` list blocking secret-bearing paths. Minimum:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "deny": ["Read(./.env)", "Read(./.env.*)", "Read(./secrets/**)"]
  }
}
```

- Extend per repo for additional secret paths (`appsettings.Local.json`, `*.pfx`, `*.pem`, credential dumps)
- Agents MUST NOT propose removing entries to "make a task work"; surface to the user

## Data exposure

- Return only fields the client actually needs
- Avoid exposing internal identifiers, flags, infra details unless part of the product contract
- Treat PII with extra care in logs, payloads, error responses

## Shared infrastructure wiring

When the project ships a shared infrastructure library (see `dotnet-shared-infrastructure`):

- At-rest encryption for stored tokens/secrets uses the library's value converter (e.g. `EncryptedStringConverter`) via `.HasConversion(...)`; never store provider/refresh tokens in plaintext
- Outbound HTTP from external user input goes through the library's URL-safety validator (blocks SSRF: internal hosts, private nets, non-HTTPS)
- Service-to-service HTTP forwards the inbound bearer via the library's bearer-forwarding `HttpMessageHandler`; never construct an `HttpClient` to a sibling API without registering it
- Authorization enforced through named policy constants and roles transformed by the library's claims transformation; never branch on raw claim strings inline
