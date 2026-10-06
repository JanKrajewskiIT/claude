---
name: solidjs-library-audit
description: Audit a SolidJS and TypeScript component library for code quality, consistency, accessibility, CSS Modules conventions, security, and tooling. Use when asked whether a library, especially LLM-generated code, follows best practices, SOLID, and consistent patterns, or to list its defects before refactoring.
---

# SolidJS Library Audit

## Goal

- Produce an evidence-backed, ranked list of defects and convention gaps for a SolidJS component library.

## When To Use

- Review a whole library or a large directory rather than one component.
- Judge generated code against the loaded rules and decide what to fix first.

## Do Not Use

- Use `solidjs-component` to build or refactor one component.
- Use `dom-hygiene-audit` for markup-only simplification.
- Use `typescript-library` for package exports and publishing.

## Workflow

1. Load context.
   - Read `AGENTS.md`, the matching rules, and the repository instructions.
   - Read `package.json`, compiler, lint, style-lint, build, hook, and CI configuration.
   - Treat documentation as intent and report where executable evidence disagrees.
2. Measure mechanical consistency.
   - Run only read-only search; do not run builds, tests, or linters without approval.
   - Use the probes in [`references/audit-probes.md`](references/audit-probes.md).
3. Read a stratified sample.
   - Read the largest component, every shared hook, the overlay and dropdown primitives, one form control, one data component, and the provider and theme modules.
   - Read the global stylesheet and two component stylesheets.
4. Judge each dimension.
   - Cover SOLID and cohesion, reactivity, state ownership, typing, accessibility, CSS, localization, security, tooling, and tests.
   - Mark a finding confirmed only when a file and line prove it; otherwise mark it a hypothesis.
5. Separate rule violations from rule gaps.
   - If an existing rule already forbids the pattern, report a violation.
   - Otherwise propose a new rule bullet in the owning rule file.
6. Report.
   - Order findings by severity: security and correctness, accessibility, state and lifecycle, consistency, style.
   - Give file and line, the triggering condition, and the smallest fix.
   - State which checks remain unrun and propose exact commands.

## Constraints

- Do not edit source, tests, or generated agent directories during an audit.
- Do not rewrite shared rules unless the user asks to record the findings.
- Edit rules only in the canonical rules directory, never in installed copies.

## Output

- A ranked findings list, a rule-violation versus rule-gap split, and the unrun checks.

## Completion Criteria

- Every finding cites evidence and a minimal correction.
- Every dimension in step 4 has a verdict or an explicit "not assessed".
- Proposed rule changes avoid duplicating existing rules.
