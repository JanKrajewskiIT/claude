---
name: component-library-i18n-migration
description: Move hard-coded user-visible defaults of a component library into typed per-group dictionaries and extract a shared vocabulary. Use when localizing a UI library, adding a locale, splitting the work across agents by component group, or deduplicating repeated labels such as Cancel and Save.
---

# Component Library I18n Migration

## Goal

- Every user-visible default of the library comes from a typed dictionary in each supported locale, and repeated wording is defined once.

## When To Use

- A library ships English literals in components and helpers.
- A shared vocabulary must replace repeated labels.

## Do Not Use

- Designing the i18n core, locale resolution or formatting: use `typed-i18n`. This skill applies its schema and ownership rules to a component library.
- Application copy: it stays in the application.

## Workflow

1. Build the foundation before delegating.
   - Create `en/<group>.ts` with `defineDictionary` and `pl/<group>.ts` typed `TranslationOf<typeof <group>En>`.
   - Register groups under one root key such as `library.<group>.<component>.<message>`.
   - Augment the i18n dictionary type with the English tree so keys are typed.
   - Provide `useTranslate` and a rich-text variant that fall back to the bundled English text when the host did not compose the library messages.
   - Export the library messages for composition with application dictionaries.
2. Pilot on varied components.
   - Cover a plain default, a label table of typed keys, plural messages, rich text and a helper module.
3. Define conversion rules.
   - Let explicit props override the dictionary default: `props.label ?? translate(key)`.
   - Use `=== undefined` where an empty string is a valid override.
   - Replace exported default label constants with keys. Treat this as a breaking change.
   - Keep keys literal. Allow dynamic access only through tables of literal keys.
   - Resolve each label in the component that renders it instead of passing translated labels down as props.
   - Write plural forms per locale; Polish needs one, few, many and other.
   - Add a lint rule that rejects literal keys passed to the runtime-key translator.
4. Delegate by group.
   - Split large groups by file-name range.
   - Append to existing dictionary files; never recreate them.
   - Use [`references/delegation-brief.md`](references/delegation-brief.md).
5. Verify delegated work by evidence.
   - Check that dictionary keys are used by components. Unused keys mean a silent failure.
   - Finish incomplete groups manually.
   - Read editor diagnostics for every changed file.
6. Extract the shared vocabulary.
   - Create a `common` group with the most frequent words, choosing wording by frequency in each locale.
   - Merge an entry only when the English value and the translation both equal the common value exactly.
   - Keep entries with different wording, an ellipsis, placeholders or another meaning.
   - Replace every usage, including key tables, other groups and demos. Remove emptied parents.
   - Confirm no reference to a removed key remains.
7. Propose validation.
   - Typecheck, lint and a locale parity check, with exact commands.
   - Ask a native speaker to review translations.

## Constraints

- Do not run commands without approval; use editor diagnostics.
- Do not write tests unless requested.
- Do not add dependencies.
- Do not change existing keys during parallel work.

## Output

- Dictionaries per group and locale, the common group, updated components.
- A list of merged keys and skipped entries with reasons.
- A list of breaking changes for consumers.

## Completion Criteria

- No user-visible English literal remains in components or helpers, except values intentionally supplied by consumers.
- English and translated dictionaries have identical key structure by type.
- No unused or removed key is referenced.
- Unrun checks and unreviewed translations are reported.
