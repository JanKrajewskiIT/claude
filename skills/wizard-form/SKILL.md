---
name: wizard-form
description: Multi-step form pattern with a single use-hook owning step state, draft form state, mutations, computed flags, and handlers. Use when building a dialog/wizard with sequential steps.
---

> Type: Skill (operational playbook)

Use this playbook for any multi-step form (add-offer wizard, onboarding flow, multi-step settings dialog).

Normative constraints live in `solidjs-tsx`, `reactivity-performance`, `state-and-data-flow`, `velvet-consumer-frontend`, and `i18n`.

## Standard Workflow

1. Declare a `Step` union (`'parse' | 'review' | 'confirm'`) and a `STEP_LABEL_KEYS: Record<Step, DictKey>` at the module top
2. Define a `FormState` interface using `'' | LiteralUnion` for unselected select values and `string` for numeric inputs
3. Build a single hook `use<Wizard>(onClose)` that owns:
   - `step` signal, `parseMode` signal (when applicable), `formState` signal, `error` signal
   - All mutations (`useXxxMutation()` from the feature store)
   - Computed memos (`dialogTitle`, `isNextDisabled`, `isSubmitDisabled`, `visibleSteps`)
   - Handlers (`handleNext`, `handleBack`, `handleSubmit`, `handleClose`, `handleFieldChange<K>`)
4. The wizard component is purely declarative: imports the hook, renders `<Stepper>` + per-step content, wires buttons
5. Field updates use the typed `handleFieldChange<K extends keyof FormState>(field: K, value: FormState[K])` to keep the contract type-safe

## Required Conventions

- One hook owns the entire flow; do NOT spread step state across child components
- Mappers (`mapParseResultToForm`, `buildNewOffer`) live in the same hook file or `~/store/<feature>.ts`
- Use VelvetUi `<Stepper>`, `<FormLayout>`, `<FormField>`; never reinvent step navigation
- Step labels resolve through `ts(STEP_LABEL_KEYS[step()])`

## Before Finishing

- Confirm `handleClose` resets the wizard so reopen starts at step 1 with empty state
- Verify `isNextDisabled` covers BOTH validation and pending-mutation states
- Check that conditional steps are hidden via `visibleSteps` memo, not via inline `<Show>` around step indicators
