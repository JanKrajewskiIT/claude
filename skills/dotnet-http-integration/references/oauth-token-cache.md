# OAuth Bearer Token Cache

Use a token cache only when the upstream authentication contract requires the
application to acquire and reuse bearer tokens. Prefer the repository's
framework-managed OAuth support when it already owns the required lifecycle.

## Contract

- Keep token acquisition separate from the protected API client when endpoints, credentials, or timeouts differ.
- Store the token with verified issue and expiry times and refresh before expiry with clock-skew and network-latency margin.
- Use `TimeProvider` or the repository's clock abstraction so expiry behavior is deterministic.
- Serialize refresh so concurrent callers share one acquisition request, then recheck the cache after acquiring the lock.
- On `401`, invalidate only the token used by that request and retry at most once when the operation is retry-safe.
- Propagate a repeated `401` as an authentication failure and preserve cancellation while callers wait for refresh.

## Security

- Never log, trace, meter, serialize, or include the token in an exception.
- Keep client credentials in the approved secret provider.
- Do not assume decoding a JWT validates its issuer, audience, signature, or expiry.

## Validation

Verify first acquisition, reuse, concurrent refresh, proactive refresh, manual
invalidation, one retry after `401`, repeated `401`, acquisition failure, clock
skew, and cancellation without relying on real delays.
