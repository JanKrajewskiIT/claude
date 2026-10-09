---
name: design-system-parity-audit
description: Statically audit a ported component library against its design-system reference and fix the gaps. Use when asked whether everything in the reference was implemented, when checking DOM, props, accessibility and CSS parity without running the app, or after porting a group of components.
---

# Design System Parity Audit

## Goal

- Find and fix every difference between a port and its reference that is not an accepted deviation.

## When To Use

- A port exists and parity is unverified.
- The reference was updated and the port must follow.

## Do Not Use

- Writing the port: use `design-system-solid-port`.
- Comparing against an older implementation of the same library: use `implementation-regression-review`.
- Judging code quality, rule violations and security of the library: use `solidjs-library-audit`. Hand file-size and convention findings to it instead of fixing them here.

## Workflow

1. Check the inputs.
   - Confirm the reference is complete: every folder named by its entry stylesheet and docs exists.
   - Stop and report if it is partial.
2. Inventory.
   - List exports of the reference type declarations and of the port.
   - Compare the count with the component count the reference documents, and report a mismatch.
   - Build an explicit mapping for renamed, merged and split exports.
   - Treat unmapped names as candidates for omission.
3. Compare CSS.
   - Hash every reference CSS, token and font file and its counterpart.
   - Treat any difference as a defect unless it is a recorded library extension.
4. Compare each component.
   - Props: names, optionality, types and defaults from the type declarations.
   - DOM: the set of class tokens, `data-*`, `aria-*`, `role`, `tabIndex`.
   - Behavior: key handlers, focus moves, timers, listeners and their cleanup, icons.
   - Aliases and callbacks the reference accepts, such as `onChange` next to `onValueChange`.
   - Specimens: compare the props and content each specimen uses with what the port accepts.
5. Compare the showcase.
   - Skip when the user excludes the showcase.
   - Group the reference specimens by their declared group and compare group names, numbering, and order with the port's demo navigation.
   - Map each specimen to a demo section; foundation specimens (tokens, colour, type, shape, depth, motion, state) need pages too.
   - Check that every public export is shown by some demo, and list exports with no demo.
   - Check that every CSS custom property a demo uses is defined in the token files.
   - Record specimens that are tooling rather than UI as accepted omissions.
6. Classify every difference.
   - Fix in place when an attribute, class, prop or branch is missing.
   - Rework when structure or behavior diverges widely.
   - Accept when a library rule requires it, such as one component per file, localized defaults or removed framework idioms. Record the reason.
   - Record as a reference issue when the reference is wrong, and port it as is.
7. Fix gaps with the smallest change.
   - Keep public props of the reference. Add a missing prop only when the reference has it.
8. Report.
   - Give counts: exports mapped, interfaces compared, files hashed.
   - List fixes, accepted deviations, and items not verifiable statically: runtime behavior, pixel parity, translation quality.
   - List proposed runtime checks with exact commands.

## Constraints

- Use read-only inspection without approval. Ask before running builds, tests or the app.
- Do not rely on reference documentation alone; trace the sources.
- Verify delegated per-group audits by evidence: an empty or vague agent answer is not a result.
- Do not change the reference or its CSS to make a difference disappear.

## Output

- A gap table: component, difference, class, action, status.
- A list of unverified areas.

## Completion Criteria

- Every reference export is mapped or explicitly omitted.
- CSS hashes are identical, or each difference is explained.
- Every classified gap is fixed or recorded with a reason.
- Showcase groups and sections match the reference, or each difference is recorded.
- Unverified areas and unrun checks are listed.

See [`references/commands.md`](references/commands.md) for inventory and hash commands.
