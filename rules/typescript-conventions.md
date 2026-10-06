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
- Type a finite option value as its literal union instead of `string` when the runtime ignores or rejects other values.
- Represent an optional feature by the presence of its options object, with its required fields required, instead of an `enabled` flag beside fields that become required only when enabled.
- Derive variant option types from a shared base with `extends`, `Omit`, or `Pick` instead of duplicating their fields.
- Make public parameter types mirror the values the runtime accepts; do not type an input as `unknown` when the runtime rejects most values.
- Do not declare a type parameter that appears only in a return type; it is an unchecked cast. Accept a parser, validator, or mapper, or return `unknown`.
- Do not publish two names for one contract unless compatibility requires it; then declare one as an alias of the other.
- Refer to an existing named alias wherever the same contract appears instead of restating its structure.
- Type the same identifier concept identically across sibling APIs, such as `string` versus `PropertyKey` ids.
- Derive the element type of a keyed helper from its key, such as `K extends keyof T` with `T[K]`, instead of accepting any string with an unrelated item type.
- Do not intersect an index-signature or template-literal-key type, such as `` `aria-${string}` ``, with named members of a different type; the intersection narrows the member and forces assertions at call sites. Exclude the named keys from the pattern type instead.
- Declare function-valued members, especially callbacks, with property syntax such as `onSave: (value: T) => void` so strict variance applies; use one member style per codebase.
- Under `exactOptionalPropertyTypes`, declare forwarded optional options as `T | undefined` or forward the options object as a whole instead of rebuilding it with conditional spreads.

## Declarations

- Declare module-level functions, factories, components, callbacks, and local helpers with `const` arrow functions.
- Use a `function` declaration only for overloads, hoisting, recursion, generators, `this` binding, or a documented framework or public API requirement.
- Do not use `this` inside getters or methods of objects returned from factories; reference closure values so destructuring and spreading stay safe.
- Use a class only when `instanceof` identity or platform subclassing, such as extending `Error`, is required.

## Narrowing

- Validate untrusted runtime data before treating it as a typed application value.
- Validate each known nested property promised by a decoded object's return type; a top-level record check proves only a record of unknown values.
- Prefer type guards, assertion functions, schema validation already owned by the repository, or `satisfies` over broad type assertions.
- Use a type assertion only when a runtime invariant exists but TypeScript cannot express it; keep the assertion local to that boundary.
- Avoid non-null assertions when control flow, an early return, or a narrower type can prove presence.
- Handle discriminated unions exhaustively and make newly added variants visible to the compiler.
- Use a `switch` on the discriminant with a `never` check in the default branch instead of an `if` chain whose final branch is implied.
- Do not use double assertions such as `as unknown as T`; declare ambient globals or narrow optional platform APIs with guards.
- Do not guard a browser API, such as `typeof document === 'undefined'`, inside a code path that only runs in the browser, such as a client-only effect.

## Boundaries

- Keep transport, persistence, domain, and view-model types separate when their contracts evolve independently.
- Map external values at their owning boundary instead of spreading nullable, unvalidated, or third-party shapes through the application.
- Keep third-party types out of public contracts when they create avoidable coupling.
- Reuse a shared type only when consumers share the same semantics, not merely the same current fields.
- Put required arguments before optional ones in public functions, or accept one options object; do not make callers pass `undefined` positionally.
- Generate declarations from one typed source, either TypeScript or JavaScript checked with JSDoc and `checkJs`; when a declaration file is hand-authored, type-check a consumer of every export against it during validation.
- Export every type reachable from a public signature so consumers can name it.
- Do not expose internal mutable handles, such as state setters, cache entries, or mutable defaults, through public interfaces; mark exposed configuration `readonly`.
- Encode dynamic URL path segments with `encodeURIComponent` before interpolating them into a request path.

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
- Avoid circular imports between modules, including type-only cycles; move the shared type to the lower-level module.
- Export declarations inline at their definition instead of mixing inline exports with trailing `export type { ... }` lists in one codebase.

## Completion Criteria

- External data is narrowed or validated before typed use.
- Public contracts contain no accidental `any`, assertion, or third-party coupling.
- State variants and nullable values are handled explicitly.
- Shared types represent shared semantics rather than coincidental structure.
- Module names and exports expose focused responsibilities.
- Union handling is exhaustive and no double assertion bypasses the type system.
- Public option types make invalid combinations unrepresentable and agree with the runtime they describe.
- Every type reachable from a public signature is exported, no return-only type parameter hides a cast, and no internal mutable handle is public.
- Functions follow the `const` arrow default, and every `function` declaration or class has a language-level reason.