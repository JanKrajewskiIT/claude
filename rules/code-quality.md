# Code Quality

## Scope

- Apply this rule when creating, changing, or reviewing source code in any stack.
- Apply stack rules for language- and framework-specific conventions.

## Single Source of Truth

- Define each finite set, default value, and configuration constant once and derive every check, guard, type, and message from it.
- Do not repeat literal members of a defined set in validation, detection, or diagnostic text.
- Resolve a defaulted input once and reuse the resolved value instead of repeating the fallback expression.
- Keep one implementation for one algorithm; extract shared steps when two code paths differ only in their output representation.

## Responsibilities

- Give each function and module one reason to change.
- Replace boolean or mode parameters that switch between behaviors with separate functions or an explicit variant type.
- Keep pure computation free of logging, persistence, and other side effects.
- Keep extension points open where consumers credibly need to add variants without a library release.

## Consistency

- Use one declaration style, naming convention, import style, and file-extension policy throughout a codebase.
- Introduce a different paradigm, such as a class among functional modules, only when it owns state or lifecycle that functions cannot express clearly.
- Name values for their domain meaning, not their implementation mechanism.

## Dead and Redundant Code

- Remove branches that cannot execute, checks already guaranteed by types or earlier validation, and temporary variables returned unchanged.
- Remove redundant validation that repeats a guarantee already enforced by a parser, pattern, or type.
- Remove fields, flags, and result properties that no caller reads.

## Resources and State

- Bound every module-level cache, registry, and deduplication set, or scope it to an owner with a defined lifetime.
- Do not key diagnostics or caches by unbounded user-controlled or content-derived values without a bound.
- Reuse expensive platform objects, such as formatters and compiled patterns, when inputs repeat on hot paths.

## Failure Handling

- Keep `try` blocks limited to the operation that can fail for the expected reason.
- Recover from a local defect locally when the contract allows partial results, instead of failing the whole operation.
- Keep diagnostics observable in the environment where they are intended to fire and verify that build tooling does not remove them.

## Completion Criteria

- Every finite set and default has one authoritative definition.
- No duplicated algorithm, flag-driven function, or impure computation remains.
- Declarations, names, imports, and file extensions follow one convention.
- No unreachable branch, redundant check, or unread state remains.
- Long-lived caches and diagnostic sets are bounded or owned.
