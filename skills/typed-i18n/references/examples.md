# Typed Internationalization Examples

## Source-Derived Dictionary

```ts
const en = {
  project: {
    saved: "Project saved",
    memberCount: "{count, plural, one {# member} other {# members}}",
  },
} as const;

type Dictionary = TranslationOf<typeof en>;
```

Other locale dictionaries implement `Dictionary`, making missing keys visible
before runtime. The exact type helper depends on the selected i18n library.

## Complete Message

```text
Avoid: translate("results.prefix") + count + translate("results.suffix")
Use:   translate("results.count", { count })
```

A complete message allows translators to reorder values and apply locale plural
rules.

## Locale-Aware Formatting

```ts
new Intl.DateTimeFormat(locale, {
  dateStyle: "medium",
  timeZone,
}).format(instant);
```

Store and transport the instant independently from its localized presentation.
