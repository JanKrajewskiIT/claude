# Query Primitives

Rules for implementing query, mutation, pagination, and cache primitives locally
instead of consuming a maintained query library.

## Cache Entries

- Key entries by a canonical hash whose static type mirrors the values the
  hash accepts; reject unsupported values at the type level, not only at runtime.
- Store the normalized key with the entry so partial-key matching does not
  re-normalize every entry on each invalidation.
- Count active observers per entry. Garbage-collect only entries with no
  observers, no in-flight request, and an expired idle period.
- Abort an entry's in-flight request when the entry is removed or the client is
  disposed, and detach no live observer silently.
- Keep entry state setters internal; expose read accessors and documented
  commands such as `setQueryData` and `invalidate`.
- Type `getQueryData` and `setQueryData` symmetrically so callers do not cast.

## Fetching

- Run the retry loop as a standalone function that receives the request,
  retry policy, delay policy, and `AbortSignal`.
- Build abort, success, and failure state transitions with one named builder
  each instead of repeating object literals.
- Reject aborted work with a `DOMException` named `AbortError`.
- Consume rejections of automatic fetches after updating state; reject only
  explicit `refetch` calls.
- Treat a key switch and an invalidation of the same key as different events:
  a switch to a fresh cached entry must not refetch.

## Invalidation

- Mark invalidated entries stale and refetch only observed entries.
- Never serve an invalidated entry through a direct cache read, such as an
  infinite query that reuses a cached next page.
- Register each invalidation trigger, such as an access-token change, once per
  composed primitive; a wrapper must not duplicate the trigger of the primitive
  it wraps.

## Mutations

- Assign each run a sequence number and let only the latest run write state.
- Pass callback context as a required `TContext | undefined` parameter.
- Define one channel for exceptions thrown by success, error, and settled
  callbacks, and apply it on every path.

## Wrappers

- Forward options to the wrapped primitive as one object instead of rebuilding
  it field by field with conditional spreads.
- Expose one result shape for every wrapper: share status flags such as
  `isLoading`, `isFetching`, `isError`, `isSuccess`, and `error` through one
  interface and one builder.
- Memoize selected or flattened data so repeated reads return the same value.
- Surface errors of secondary requests, such as loading the next page, in
  wrapper state.

## Context

- Resolve the client from context only during synchronous setup under an owner.
- Require an explicit client argument for helpers callable from event handlers,
  or capture the client during setup and return a bound function.
- Emit a development diagnostic when falling back to a default client outside a
  provider.

## Boundaries

- Render loading, error, and success branches with `Switch` and `Match`, or
  `Show`, so a refetch that keeps the same branch does not recreate children.
- Do not check `instanceof Error` on a value already typed as `Error`.
