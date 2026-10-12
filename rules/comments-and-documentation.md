# Comments And Documentation

## Scope

- Apply this rule when creating or changing source code, tests, scripts, configuration, deployment manifests, or documentation.

## Comments

- Write names, structure, types, and boundaries that communicate behavior without explanatory narration.
- Add a comment only when it preserves a non-obvious reason, constraint, workaround, compatibility requirement, or operational hazard that cannot be expressed clearly in the implementation.
- Explain why a surprising decision is necessary, not what adjacent code does.
- Remove comments that repeat syntax, narrate control flow, restate names, preserve obsolete behavior, or compensate for structure that can be improved directly.
- Keep tool directives, suppressions, schema annotations, and generated-file notices narrowly scoped and include their reason when the format permits it.

## Configuration

- Prefer descriptive keys, cohesive sections, typed schemas, validation, and repository conventions over comments that teach the file format.
- Document only non-obvious operational constraints, external compatibility requirements, and intentionally surprising values near configuration when needed for safe changes.

## Project Documentation

- Keep architecture, domain language, business rules, workflows, decisions, and operational explanations in the owning project's documentation location.
- Keep comments local to implementation details and link canonical documentation instead of embedding architectural or business essays in code.
- Link external documentation only when it is authoritative, directly relevant, and materially supplements local guidance.
- Add links between local pages only when readers need the contextual transition; do not duplicate navigation mechanically.
- Update documentation when a change alters an architectural boundary, business behavior, public contract, or operational procedure.
- Do not duplicate the same explanation across comments, configuration, and documents.

## Completion Criteria

- Remaining comments explain non-obvious intent or constraints rather than observable mechanics.
- Code and configuration remain understandable through naming, structure, types, and validation.
- Architecture and business knowledge lives in the owning documentation location.
- Links provide necessary context rather than speculative resource lists.
- Comments and documentation contain no stale or duplicated explanation.
