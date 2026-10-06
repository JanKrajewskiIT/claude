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

## Responsibilities

- Give each function and module one reason to change.
- Replace boolean or mode parameters that switch between behaviors with separate functions or an explicit variant type.
- Keep pure computation free of logging, persistence, and other side effects.
- Keep extension points open where consumers credibly need to add variants without a library release.
- Build sibling factories or variants from one shared base and add only their differences.

## Consistency

- Use one declaration style, naming convention, import style, and file-extension policy throughout a codebase.
- Use one parameter shape for sibling public functions, including argument order, defaulting, and where validation happens.
- Introduce a different paradigm, such as a class among functional modules, only when it owns state or lifecycle that functions cannot express clearly.
- Name values for their domain meaning, not their implementation mechanism.
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

## Failure Handling

- Keep `try` blocks limited to the operation that can fail for the expected reason.
- Recover from a local defect locally when the contract allows partial results, instead of failing the whole operation.
- Keep diagnostics observable in the environment where they are intended to fire and verify that build tooling does not remove them.
- Do not convert a failure into an empty or default result when the caller explicitly requested the behavior that failed.
- Validate every input of a public entry point at one boundary and name the allowed values, derived from their source set, in the error message.

## Completion Criteria

- Every finite set and default has one authoritative definition, and dependent defaults derive from their source option.
- No duplicated algorithm, sibling factory, repeated guard, flag-driven function, or impure computation remains.
- Declarations, names, imports, parameter shapes, and file extensions follow one convention.
- No unreachable branch, redundant check, ineffective input, or unread state remains.
- Explicitly requested behavior fails observably instead of degrading silently.
- Long-lived caches and diagnostic sets are bounded or owned.
