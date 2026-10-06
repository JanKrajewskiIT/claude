---
name: typed-i18n
description: Design, implement, migrate, or review type-safe internationalization in applications and libraries. Use when defining translation schemas, locale dictionaries, message keys, interpolation, plurals, rich text, locale fallback, formatting, language direction, or translation ownership.
---

# Typed Internationalization

## Goal

- Make missing or incompatible translations visible before runtime where practical.
- Keep language, formatting, direction, and message ownership explicit.

## Workflow

1. Define locale support.
   - Identify the source locale, supported locales, fallback policy, and ownership of translations.
   - Distinguish language from region, script, and user formatting preferences.
   - In reusable libraries, let consumers configure the supported-locale set instead of hardcoding it in the library.
   - Derive detection, validation, fallback, and locale types from one supported-locale source.
2. Define the message schema.
   - Organize keys by stable feature or semantic ownership.
   - Derive dictionary types from the source schema or generate types from a shared contract.
   - Keep parameter names and value types consistent across locales.
3. Design messages.
   - Translate complete semantic messages instead of concatenating fragments.
   - Use named interpolation for dynamic values.
   - Use locale-aware plural and selection rules rather than binary string branches.
   - Use structured rich-text placeholders instead of embedding unsafe markup.
   - Use [`references/examples.md`](references/examples.md) for typed schemas and complete-message patterns.
4. Resolve locale.
   - Define precedence among explicit user choice, persisted preference, account setting, browser preference, and fallback.
   - Normalize locale tags before matching supported locales.
   - Persist only an intentional user choice.
   - Resolve a persisted client locale before the first client render to avoid a default-locale flash.
5. Format locale-sensitive values.
   - Use platform internationalization APIs for dates, times, numbers, currencies, units, lists, and relative time.
   - Keep storage and transport values locale-neutral.
   - Specify a time zone when the displayed instant depends on one.
   - Reuse `Intl` formatter and plural-rule instances keyed by locale and options on render paths.
6. Apply document language and direction.
   - Set language metadata for the rendered document or isolated content.
   - Derive text direction from the resolved locale or content requirement.
   - Use logical layout properties where bidirectional layout is supported.
7. Separate library and application ownership.
   - Let reusable libraries own generic messages required by their behavior.
   - Let applications own domain language, workflow copy, and product terminology.
   - Provide namespacing or dictionary composition without coupling libraries to app keys.
8. Handle failure states.
   - Define behavior for missing locale, key, parameter, formatter, and loading failure.
   - Keep development diagnostics useful without exposing internal keys to users in production.
   - Report missing keys, fallback hits, and invalid templates in development.
   - Recover from a malformed rich-text tag locally, including inside plural and select branches, instead of discarding the whole message.
9. Propose validation.
   - Check schema parity, parameter compatibility, fallback, plural categories, formatting, direction, long text, and missing-key behavior.
   - Treat a hand-written message parser without grammar-level tests for escapes, nesting, malformed input, and passthrough as incomplete, and report the gap.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation | Decision |
|---|---|
| Message contains reordered dynamic values | Use one complete message with named parameters. |
| Count changes grammar | Use locale-aware plural rules. |
| Library message is generic and required internally | Keep it in the library namespace. |
| Copy describes product workflow or domain data | Keep it in the application namespace. |
| Locale is unsupported | Apply the documented fallback chain. |

## Constraints

- Do not use visible source text as a translation key for maintained applications.
- Do not concatenate translated fragments.
- Do not format dates or numbers with manual string templates.
- Do not assume left-to-right layout or one plural rule.
- Do not allow rich translations to inject arbitrary HTML.
- Do not restate supported-locale literals outside their single source.
- Do not implement plain and rich rendering as two copies of the same selection logic.

## Completion Criteria

- Locale resolution and fallback are deterministic.
- Dictionary shape and message parameters are type-checked or statically validated.
- Messages support grammar without fragment concatenation.
- Formatting and direction follow the resolved locale.
- Translation ownership is clear across libraries and applications.
- Every locale check derives from one supported-locale source.
- Message parsing has grammar-level test coverage or the gap is reported.
