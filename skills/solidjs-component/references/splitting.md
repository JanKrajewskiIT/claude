# Splitting A Large Component

Use when a component module exceeds about 250 lines, owns more than one independent state machine, or passes more than about 15 props to one child.

## Seams

| Code                                                     | Destination                                                                                     |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Independent behavior with signals, effects, or listeners | `create<Behavior>.ts` hook that takes accessors or callbacks and returns accessors and handlers |
| Markup with its own state or a distinct semantic role    | Sub-component in its own file named after its export                                            |
| Pure computation, formatting, geometry, or layout        | Module named for the behavior, with no side effects                                             |
| Types, constants, and the merged-props type              | `<name>Types.ts`, the lowest-level new module                                                   |

## Controller Object

- Compose the hooks once in the owning component and pass the result to children as one `controller` prop.
- Declare the controller type in `<name>Controller.ts`; keep it minimal and readonly where consumers must not mutate it.
- Type the defaulted props as one `<Name>Config` (the props plus the required defaults) so every part reads resolved values.
- Do not split state that parts must share into per-part signals; keep one owner.

## Reactivity

- A hook reads props only inside accessors, memos, effects, and handlers.
- A child that hands `props.controller` to a hook during setup relies on the controller never being replaced. Either accept an accessor or scope one suppression with that reason.
- Wrap handlers taken from a prop object, such as `(e) => props.controller.onKeyDown(e)`; passing them directly is not reactive.
- Pass element refs through setter callbacks or accessors when effects in another module need them after mount.
- Keep the relative order of effects, `onMount`, and cleanup registrations that depended on each other.

## Contract

- The original file keeps its public exports and re-exports every moved public type.
- Group barrels and consumers stay unchanged; new modules stay internal unless they were already public.
- DOM, class names, ARIA, keyboard behavior, i18n keys, props, and defaults stay identical.
- Move each `eslint-disable-next-line` directive together with the code it covers.

## Stop Rule

- Stop when every remaining piece has an independent responsibility; do not extract for line count alone.
- Prefer a smaller main file only when the extracted pieces are named for behavior, not for position.

## Delegated Work

- Give each agent one to three files, the seam rules above, and a ban on commands unless the user approved them.
- Verify by evidence, not by the report: check the line count of the main file, confirm it imports every new module, look for new files that nothing uses, and read diagnostics for each touched file.
- An empty or partial agent result is not completion; list the files that were left unwired and finish them.
- Read the full diff for moved suppressions, effect order, and re-exports before accepting.
