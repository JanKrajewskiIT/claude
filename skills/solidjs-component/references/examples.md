# SolidJS Component Examples

## Reactive Defaults and Forwarding

```tsx
const Action = (props: ActionProps) => {
  const merged = mergeProps({ type: "button" as const }, props);
  const [local, buttonProps] = splitProps(merged, ["label", "onPress"]);

  return (
    <button {...buttonProps} onClick={local.onPress}>
      {local.label}
    </button>
  );
};
```

`mergeProps` and `splitProps` preserve reactive property access. Avoid
`const { label } = props` when the value can change.

## External Resource Cleanup

```tsx
onMount(() => {
  const observer = new ResizeObserver(handleResize);
  observer.observe(element);
  onCleanup(() => observer.disconnect());
});
```

Cleanup belongs beside ownership of the listener, observer, timer, or imperative
integration.
