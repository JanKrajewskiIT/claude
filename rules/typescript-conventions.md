# TypeScript Conventions

## Scope

- Apply this rule to TypeScript and TSX source files.
- Follow stricter repository compiler, lint, and public API conventions when present.

## Types

- Prefer `unknown` over `any` at an unresolved boundary and narrow it before use.
- Use `any` only when an external contract cannot be modeled more safely and keep it at the narrowest boundary.
- Model finite states and variant-specific data with discriminated unions.
- Make invalid states unrepresentable when a small type model can express the invariant clearly.
- Infer local implementation types when intent remains clear; type exported and cross-module contracts explicitly.
- Prefer `readonly` data when consumers must not mutate shared inputs.
- Derive literal unions, type guards, and runtime validation from one `as const` source instead of restating member literals.
- Give each union variant only the fields valid for it, such as a style union per format, instead of a shared loose `string` that later requires assertions.
- Extract a named alias for a value union reused across several types instead of repeating it.

## Narrowing

- Validate untrusted runtime data before treating it as a typed application value.
- Prefer type guards, assertion functions, schema validation already owned by the repository, or `satisfies` over broad type assertions.
- Use a type assertion only when a runtime invariant exists but TypeScript cannot express it; keep the assertion local to that boundary.
- Avoid non-null assertions when control flow, an early return, or a narrower type can prove presence.
- Handle discriminated unions exhaustively and make newly added variants visible to the compiler.
- Use a `switch` on the discriminant with a `never` check in the default branch instead of an `if` chain whose final branch is implied.
- Do not use double assertions such as `as unknown as T`; declare ambient globals or narrow optional platform APIs with guards.

## Boundaries

- Keep transport, persistence, domain, and view-model types separate when their contracts evolve independently.
- Map external values at their owning boundary instead of spreading nullable, unvalidated, or third-party shapes through the application.
- Keep third-party types out of public contracts when they create avoidable coupling.
- Reuse a shared type only when consumers share the same semantics, not merely the same current fields.

## Modules

- Keep modules focused on one responsibility and avoid side effects during import unless initialization is the module's explicit contract.
- Use type-only imports and exports when values are not required at runtime.
- Prefer named exports for reusable modules unless the framework or repository establishes a different public convention.
- Avoid generic `utils` modules; place reusable code in a module named for its behavior or boundary.
- Import each module once per statement kind and use one type-import style, either `import type` statements or inline `type` modifiers, across the codebase.
- Import a shared type from its owning module rather than from a re-exporting module.
- Use the `.tsx` extension only for modules that contain JSX.
- Use one naming convention for module-level constants regardless of whether they are exported.
- Scope lint suppressions to the declaration that needs them instead of disabling a rule for a whole file.

## Completion Criteria

- External data is narrowed or validated before typed use.
- Public contracts contain no accidental `any`, assertion, or third-party coupling.
- State variants and nullable values are handled explicitly.
- Shared types represent shared semantics rather than coincidental structure.
- Module names and exports expose focused responsibilities.
- Union handling is exhaustive and no double assertion bypasses the type system.