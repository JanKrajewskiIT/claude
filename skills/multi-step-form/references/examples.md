# Multi-Step Form Examples

## State Model

```ts
type FormPhase =
  | { status: "editing"; stepId: string }
  | { status: "validating"; stepId: string }
  | { status: "submitting" }
  | { status: "succeeded"; resultId: string }
  | { status: "failed"; kind: "validation" | "conflict" | "transient" };

type FormState<TValues> = {
  values: TValues;
  visitedStepIds: ReadonlySet<string>;
  phase: FormPhase;
};
```

The union prevents contradictory flags such as `isSubmitting` and `isSucceeded`
being true simultaneously. Step completion remains derived from `values` and the
validation schema.

## Transition Outline

```text
editing(step A)
  -> validate A
  -> editing(next applicable step)
  -> validate all
  -> submitting
  -> succeeded | failed
```

Changing an earlier answer must recalculate the next applicable step and decide
what happens to values owned by steps that no longer apply.
