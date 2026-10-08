# Delegation Briefs

Run agents one after another. Give each a self-contained brief. State the forbidden actions first.

## Conversion Brief

```
Task: move every hard-coded user-visible English default string into the i18n layer (locales en and pl) for <folders or file-name range>.
Write code only. Do not run terminal commands, do not write or modify tests, do not touch <reference folder>, do not add dependencies, do not create markdown files.
Check changed files with the editor diagnostics tool.
Read first as the pattern: <useTranslate file>, <registry files>, <converted examples>.
Rules:
- Append keys to the existing dictionary files; do not recreate them and do not change existing keys.
- Props override defaults. Use a table of literal keys for helpers.
- Use the rich-text hook for messages with <tag> markup.
- Write Polish plural forms (one, few, many, other).
Finish every file in scope before reporting. Report the keys added and files changed.
```

## Dedupe Brief

```
Background: dictionaries per group in en/<group>.ts and pl/<group>.ts; keys addressed as '<root>.<group>.<path>'.
Common group: <list of key: en -> pl>.
Task for groups <list> only:
- Find entries whose English value equals a common value exactly (case, no ellipsis, no placeholders).
- Merge only if the translation equals the common translation exactly. Otherwise skip.
- Delete the entry in both locales; remove emptied parents.
- Replace every usage across src and demos with the common key. Skip any parent whose keys are built dynamically.
- Check changed files with diagnostics. Confirm no reference to a removed key remains.
Report: old key -> common key for each merge, and skipped entries with the reason.
```

## Handling Weak Results

- An empty answer means the work is unverified. Check key usage with a search and redo the group.
- A diagnostic about a missing module that points at an existing file is usually stale; confirm the file exists.
- When the common translation of a word conflicts with local wording, pick the most frequent wording and update the common group before the next batch.
