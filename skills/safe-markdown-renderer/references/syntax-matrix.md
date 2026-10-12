# Syntax And Safety Matrix

## Supported Syntax

| Area   | Syntax                                                                                                                                                   |
| ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Blocks | ATX and setext headings, paragraphs with hard breaks, fenced code with backticks or tildes, block quotes, rules, tables with alignment and escaped pipes |
| Lists  | Ordered with start number, unordered, nested to any depth within the cap, task items with nesting                                                        |
| Inline | Bold, italic with stars or underscores, bold italic, strike, code spans, backslash escapes                                                               |
| Links  | Inline with title, reference definitions with full, collapsed and shortcut forms, angle autolinks, bare URLs with trailing punctuation trimmed           |
| Images | Inline with title and plain-text alt                                                                                                                     |

## Not Supported

- Raw HTML, footnotes, indented code blocks, loose list paragraphs, nested emphasis edge cases of the full specification, bare `www.` links.

## Safety Cases To Check

| Input                                          | Expected                              |
| ---------------------------------------------- | ------------------------------------- |
| `<script>alert(1)</script>`                    | Escaped text.                         |
| `[x](javascript:alert(1))`                     | Link to `#`.                          |
| A link whose target starts with a double slash | Link to `#`.                          |
| `![a" onerror="x](https://a/b.png)`            | Alt text escaped, no extra attribute. |
| `https://a.com/<https://b.com/x>`              | No attribute breakout.                |
| `[x](https://a.com/` + code span + `)`         | URL does not contain markup.          |
| Input containing the placeholder character     | Character removed.                    |
| Deeply nested quotes or lists                  | Rendering stops at the depth cap.     |
| `https://a.com/a_b_c`                          | Underscores unchanged inside the URL. |

## Syntax Cases To Check

- Heading ids are unique and keep non-ASCII letters.
- A line ending in two spaces or a backslash becomes a line break.
- A document with a definition inside a fence keeps the fence content unchanged.
- A list item with a continuation line and a nested list renders both.
