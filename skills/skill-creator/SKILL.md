---
name: skill-creator
description: Create, update, review, or restructure portable Agent Skills. Use when a user asks to make a skill, write SKILL.md, package reusable agent instructions, improve skill discovery, or validate a skill against the Agent Skills specification.
---

# Skill Creator

## Goal

- Produce a focused, portable, and testable Agent Skill.
- Follow the open Agent Skills specification.
- Work reliably with small and large language models.

## Workflow

1. Define the task.
   - State one outcome the skill owns.
   - List explicit triggers and non-goals.
   - Identify neighboring skills and the condition for handing work to each owner.
   - Identify required inputs, outputs, tools, and constraints.
   - Confirm the task is a reusable, on-demand workflow.
   - Use always-on instructions for global behavior and a template for a fixed output shape.
2. Inspect the environment.
   - Reuse project conventions and nearby skills.
   - Confirm version-sensitive facts from primary documentation.
   - Do not assume a specific agent, model, OS, shell, or tool name.
3. Design the package.
   - Start from [`assets/SKILL.template.md`](assets/SKILL.template.md).
   - Keep the main workflow in `SKILL.md`.
   - Put optional detail in `references/` and reusable files in `assets/`.
   - Isolate time-sensitive tool guidance in a reference file.
   - Add `scripts/` only for deterministic work that instructions cannot do reliably.
4. Write the instructions.
   - Use short imperative bullets and numbered steps.
   - Start each action with a concrete verb.
   - Keep one decision, action, or constraint per bullet.
   - Put prerequisites before actions.
   - Define decision rules as explicit conditions.
   - Remove hidden decisions that require the agent to invent criteria.
   - Include only guidance that changes a decision, action, or observable result.
   - Include exact validation commands when they are portable.
   - Define stop conditions for missing inputs, unsafe actions, and unresolved ambiguity.
   - Define observable completion criteria.
   - Treat 400-700 words and 6-9 primary workflow steps as editing targets, not hard limits.
5. Review and validate.
   - Apply [`references/quality-checklist.md`](references/quality-checklist.md).
   - Remove duplication, vague language, provider assumptions, and inferable background.
   - Run `skills-ref validate <skill-directory>` when available.
   - Test one expected request and one request that must not trigger the skill.
   - Test a second realistic use case when the skill claims reuse across domains or frameworks.
   - Fix failures before reporting completion.

## Portability Rules

- Use only `name` and `description` unless an optional field is necessary.
- Keep vendor-specific metadata out of the portable skill.
- Refer to capabilities, then adapt to tools available in the current client.
- Use relative paths from the skill root.
- Keep referenced files one level below `SKILL.md`.
- Prefer structured parsers and established project tools over ad hoc processing.
- Require confirmation before destructive or irreversible actions.
- Never request, print, or store secrets in instructions, logs, or examples.

## Output

- Create `<skill-name>/SKILL.md`.
- Add only resources used by the workflow.
- Summarize created files, key decisions, and validation results.
- Report unresolved assumptions or unavailable checks.
- For reviews, report critical ambiguities first and recommend the smallest useful changes.
- Distinguish configured behavior from behavior verified through executable or live evidence.

## Completion Criteria

- The directory name exactly matches frontmatter `name`.
- `description` says what the skill does and when to use it.
- The workflow has a clear start, decisions, validation, and finish.
- A less capable model can follow each step without inferring hidden actions.
- The skill contains no unnecessary client-specific requirements.
