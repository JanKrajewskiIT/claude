# React To Solid Translation

## Syntax

| React                     | Solid                                                               |
| ------------------------- | ------------------------------------------------------------------- |
| `className`, `htmlFor`    | `class`, `for`                                                      |
| `useState`                | `createSignal`, read as `value()`                                   |
| `useMemo`                 | `createMemo`                                                        |
| `useEffect(fn, [])`       | `onMount` with `onCleanup`                                          |
| `useEffect(fn, [deps])`   | `createEffect(on(deps, fn, { defer: true }))`                       |
| `useLayoutEffect`         | `createRenderEffect` or `onMount`                                   |
| DOM `useRef`              | `let el!: HTMLElement` with `ref={el}`, or a signal setter as `ref` |
| `useId`                   | `createUniqueId`                                                    |
| `cond && <X/>`            | `<Show when fallback>`                                              |
| `arr.map`                 | `<For>`; `<Index>` for primitives                                   |
| `children` read twice     | `children(() => props.children)`                                    |
| `{...rest}`               | `splitProps` then spread                                            |
| destructured defaults     | `mergeProps`                                                        |
| `React.ReactNode`         | `JSX.Element`                                                       |
| `style={{ minWidth: 4 }}` | `style={{ 'min-width': '4px' }}`                                    |
| `createPortal`            | `<Portal>`                                                          |
| `key`                     | drop it                                                             |
| `forwardRef`              | accept `ref` as a prop and pass it on                               |

## Helper Set To Port First

| Helper               | Purpose                                                                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------- |
| `cx`, `modifier`     | Class joining and `base--modifier` classes.                                                             |
| date helpers         | Pure functions: `sameDay`, `addDays`, `toDate` (date-only strings to local midnight), `ymd`, `fmtDate`. |
| `tone`               | Tone constants.                                                                                         |
| `polymorphic`        | `HtmlProps<Element, OmittedKeys>` and an `as` renderer.                                                 |
| `createControllable` | Controlled or uncontrolled value with `onChange`. Returns `[get, set]`.                                 |
| `createLayer`        | One window key listener and a stack of open layers. Escape reaches only the topmost layer.              |
| `createDismiss`      | Outside mousedown and Escape for popover-like surfaces, with refocus of the trigger.                    |
| `createModal`        | Focus in, make siblings `inert`, return focus on close. Render the root through a portal.               |
| `createWidth`        | Width signal fed by a `ResizeObserver` that is disconnected on cleanup.                                 |

## Patterns That Need Care

- Trigger cloning: accept `trigger: JSX.Element | ((attributes) => JSX.Element)`. Provide the attributes object (`aria-haspopup`, `aria-expanded`, `aria-controls`, `onClick`, `onKeyDown`) and render a default button for plain content.
- Prop injection into children: provide a context and read it in the child when its own prop is undefined.
- Renderable versus config: treat `Node` or function as renderable; other objects are config.
- Measure before paint: measure in `onMount` or a render effect, re-measure when tracked values change, and observe size with a `ResizeObserver`.
- Timers and animation frames: start in handlers or effects and clear in `onCleanup`.
- Async handlers: keep the busy and error flow, record failures through an `onError` prop or observable state, and rethrow when no consumer handles them.
- Uncontrolled dialogs: mount panel content only while open, so slot content is created and disposed with the dialog.
- Splitting: move sub-parts with their own state into files such as `CascaderColumns`, `FooterLegal`, `TimeStepperColumn`; keep the DOM identical.
