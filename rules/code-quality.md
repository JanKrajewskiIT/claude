# Code Quality

## Scope

- Apply this rule when creating, changing, or reviewing source code in any stack.
- Apply stack rules for language- and framework-specific conventions.

## Single Source of Truth

- Define each finite set, default value, and configuration constant once and derive every check, guard, type, and message from it.
- Do not repeat literal members of a defined set in validation, detection, or diagnostic text.
- Resolve a defaulted input once and reuse the resolved value instead of repeating the fallback expression.
- Keep one implementation for one algorithm; extract shared steps when two code paths differ only in their output representation.
- Derive a dependent default from the option it depends on, such as an entry path from a source directory, instead of declaring an independent literal with the same meaning.
- Extract one assertion helper when the same guard and error-message shape repeats across inputs.
- Define a repeated block of literal configuration once and include or reference it where the format supports inclusion.
- Define each public default, such as page size, delay, or timeout, once as a named constant shared by every module that applies it.
- Convert unknown thrown values to errors through one helper instead of repeating `value instanceof Error ? value : new Error(...)` at each call site.
- Build each repeated state literal, such as initial, success, or reset state, through one named factory.
- Extract one helper for a repeated concurrency pattern, such as single-flight promise deduplication or an abortable delay, instead of re-implementing it per module.

## Responsibilities

- Give each function and module one reason to change.
- Replace boolean or mode parameters that switch between behaviors with separate functions or an explicit variant type.
- Keep pure computation free of logging, persistence, and other side effects.
- Keep extension points open where consumers credibly need to add variants without a library release.
- Build sibling factories or variants from one shared base and add only their differences.
- Split a factory that combines key resolution, caching, scheduling, retry, and state transitions into focused collaborators; keep algorithms such as retry loops in standalone functions.
- Do not guess the shape of external data by scanning candidate property names or nesting levels; require an explicit mapper owned by the consumer.

## Consistency

- Use one declaration style, naming convention, import style, and file-extension policy throughout a codebase.
- Use one parameter shape for sibling public functions, including argument order, defaulting, and where validation happens.
- Give sibling public factories one result shape, such as accessor functions, getter properties, or tuples, unless an external compatibility contract requires otherwise.
- Introduce a different paradigm, such as a class among functional modules, only when it owns state or lifecycle that functions cannot express clearly.
- Name values for their domain meaning, not their implementation mechanism.
- Do not use framework vocabulary, such as store, signal, or hook, in the name of something that is not that construct.
- Give each public term one meaning across the API; do not use one option name, such as `key` or `client`, for different concepts in sibling functions.
- Use one absence sentinel, `null` or `undefined`, for the same meaning throughout a codebase.
- Use one status vocabulary for equivalent lifecycle states across sibling primitives, such as `pending` instead of `pending` in one and `loading` in another.
- Use one unit-naming convention for option names, such as an `Ms` suffix on every duration or on none.
- Name a function for everything it returns or affects; rename it when its scope grows beyond its name.
- Replace nested conditional spreads and ternaries in object construction with named intermediate values or small builders.

## Dead and Redundant Code

- Remove branches that cannot execute, checks already guaranteed by types or earlier validation, and temporary variables returned unchanged.
- Remove redundant validation that repeats a guarantee already enforced by a parser, pattern, or type.
- Remove fields, flags, and result properties that no caller reads.
- Remove required or accepted inputs whose effect is always overridden or ignored by the produced result.
- Remove defensive copies of values that no code mutates.

## Resources and State

- Bound every module-level cache, registry, and deduplication set, or scope it to an owner with a defined lifetime.
- Do not key diagnostics or caches by unbounded user-controlled or content-derived values without a bound.
- Reuse expensive platform objects, such as formatters and compiled patterns, when inputs repeat on hot paths.
- Evict a cache entry only when no active observer holds it, and cancel work owned by an entry when it is removed.
- Do not serve an invalidated cache entry through a read path that bypasses refetching.
- Flush or locally persist pending debounced work when its owner is disposed; do not drop it silently.

## Concurrency

- Tag each asynchronous run with a sequence number or controller and apply its result only while it is still the latest run for that state.
- When a reactive source can switch to a different keyed resource, distinguish the switch from a change within the same resource before reacting.
- Arm a deadline timer only from the event that starts its period, such as a successful fetch; a deadline already in the past must not re-trigger work on unrelated state changes.
- Do not detect equality by comparing serialized snapshots whose text depends on property order.
- Represent cancellation with the platform's standard abort error, such as a `DOMException` named `AbortError`, so callers can distinguish it from failure.

## Failure Handling

- Keep `try` blocks limited to the operation that can fail for the expected reason.
- Recover from a local defect locally when the contract allows partial results, instead of failing the whole operation.
- Keep diagnostics observable in the environment where they are intended to fire and verify that build tooling does not remove them.
- Do not convert a failure into an empty or default result when the caller explicitly requested the behavior that failed.
- Validate every input of a public entry point at one boundary and name the allowed values, derived from their source set, in the error message.
- Preserve the primary failure when a secondary step fails; for example, a failure to parse an error response body must not replace the HTTP status error.
- Record the failure of a user-triggered or fire-and-forget operation in observable state, not only in a rejected promise.
- Do not discard exceptions thrown by consumer callbacks; surface them through one documented channel.
- Attach the original error as `cause` when wrapping it.

## Completion Criteria

- Every finite set and default has one authoritative definition, and dependent defaults derive from their source option.
- No duplicated algorithm, sibling factory, repeated guard, flag-driven function, or impure computation remains.
- Declarations, names, imports, parameter shapes, and file extensions follow one convention.
- Sibling public APIs share one result shape, absence sentinel, status vocabulary, and unit naming.
- No unreachable branch, redundant check, ineffective input, or unread state remains.
- Explicitly requested behavior fails observably instead of degrading silently.
- Long-lived caches and diagnostic sets are bounded or owned, and eviction never detaches active observers.
- Stale asynchronous completions cannot overwrite newer state, and cancellation is distinguishable from failure.
