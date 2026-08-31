# Skill Quality Checklist

## Scope

- [ ] Owns one coherent outcome.
- [ ] Lists concrete use cases and non-goals.
- [ ] Represents a reusable, on-demand workflow rather than a global rule or fixed template.
- [ ] Avoids unrelated coding or style guidance.

## Discovery

- [ ] `name` matches the parent directory.
- [ ] `name` uses 1-64 lowercase letters, digits, or single hyphens.
- [ ] `description` is 1-1024 characters.
- [ ] `description` states what the skill does and when to use it.
- [ ] Trigger terms match words users are likely to use.

## Instructions

- [ ] Actions are ordered and written as short imperative steps.
- [ ] Each action starts with a concrete verb.
- [ ] Each bullet contains one decision, action, or constraint.
- [ ] Inputs, outputs, prerequisites, and stop conditions are explicit.
- [ ] Branches use clear `if` conditions.
- [ ] No instruction requires the agent to invent unstated decision criteria.
- [ ] Every instruction changes a decision, action, or observable result.
- [ ] Examples clarify difficult decisions only.
- [ ] No critical rule exists only in an example.
- [ ] Duplicate, vague, and reliably inferable guidance is removed.
- [ ] `SKILL.md` stays below 500 lines and 5000 tokens.

## Portability

- [ ] Core behavior does not depend on a vendor or model family.
- [ ] Tool names are used only when required and available.
- [ ] OS-specific commands have alternatives or declared compatibility.
- [ ] Optional frontmatter is necessary and specification-compliant.
- [ ] Resource links are relative and no more than one level deep.
- [ ] Time-sensitive details are isolated and verified against primary sources.

## Engineering

- [ ] Existing project conventions are inspected before changes.
- [ ] Changes are minimal and preserve public contracts by default.
- [ ] Structured formats use proper parsers or established tools.
- [ ] Destructive actions require explicit approval.
- [ ] Secrets and sensitive data are never exposed.

## Validation

- [ ] Completion criteria are observable and binary.
- [ ] A focused executable check is provided where possible.
- [ ] The official format validator passes when available.
- [ ] One positive trigger case succeeds.
- [ ] One negative trigger case does not activate the skill.
- [ ] A second realistic use case succeeds when portability or cross-domain reuse is claimed.