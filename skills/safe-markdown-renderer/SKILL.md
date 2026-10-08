---
name: safe-markdown-renderer
description: Build or extend a dependency-free Markdown-to-HTML renderer whose output is safe to assign to innerHTML. Use when a library must render user or AI Markdown without a parser dependency, or when adding syntax such as nested lists, reference links or setext headings to such a renderer.
---

# Safe Markdown Renderer

## Goal

- Render a useful Markdown subset to HTML that cannot carry raw HTML or unsafe URLs.

## When To Use

- The owner chose a local renderer over an established parser plus sanitizer.
- An existing escape-first renderer needs more syntax.

## Do Not Use

- Rendering trusted rich HTML: use an established sanitizer.
- Editing UI for Markdown: that is a component task.

## Workflow

1. Confirm the decision.
   - Treat a Markdown parser as complex, standards-heavy behavior: the dependency policy and security boundaries require an established parser and sanitizer unless the owner decides otherwise.
   - If no one decided against dependencies, present the established parser and sanitizer option first, with its cost.
   - Proceed locally only on explicit approval and record the decision.
2. Fix the security model.
   - Escape every source character before any rule emits markup.
   - Emit only a closed set of tags and attributes.
   - Allow URL schemes `http`, `https`, `mailto`, anchors and relative paths; reject protocol-relative `//`.
   - Replace disallowed URLs with `#`.
3. Protect generated markup.
   - Store generated fragments in a stash and leave placeholders in the text.
   - Strip the placeholder character from input.
   - Use a private-use code point as the placeholder; a control character in a regular expression trips the standard lint rule.
   - Exclude the placeholder character from every URL character class.
   - Convert text for attributes through a plain-text function that restores fragments and strips tags.
4. Order inline rules.
   - Hard breaks, code spans, backslash escapes, angle autolinks, escape, images, inline links, reference links, bare URLs, emphasis, then restore.
   - Run emphasis last so URLs and codes are never altered.
   - Require non-word boundaries for underscore emphasis.
5. Write the block parser as recursive functions.
   - Order: fence, ATX heading, rule, quote, table, list, paragraph with setext detection.
   - Strip reference definitions first, ignoring fenced code.
   - Parse lists by indentation: same-indent items are siblings, deeper lines are children dedented and parsed recursively.
   - Cap recursion depth.
   - Make heading ids unique and Unicode-aware.
6. Keep regex hygiene.
   - Use the Unicode flag everywhere.
   - Do not combine patterns that contain numbered backreferences into one alternation; test them in an array.
   - Avoid global regexes with `exec`.
   - Keep nested quantifiers linear.
7. Document the supported syntax in the component description and a demo.
8. Propose tests only if tests were requested. Otherwise list the cases in [`references/syntax-matrix.md`](references/syntax-matrix.md) as unrun manual checks.

## Constraints

- Do not pass any user text into an attribute without escaping.
- Do not add syntax that needs raw HTML.
- Do not log or echo source content in errors.

## Output

- Renderer module, component, demo source covering the syntax, documented limits.

## Completion Criteria

- Raw HTML, `javascript:` URLs and placeholder injection render inert.
- Every documented syntax has a demo line.
- Regexes carry the Unicode flag and no combined pattern uses backreferences.
- Unrun checks are reported.
