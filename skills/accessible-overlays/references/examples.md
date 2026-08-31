# Accessible Overlay Examples

## Modal Focus Sequence

```text
trigger activation
  -> render modal and make background unavailable
  -> focus task-relevant control or semantic heading
  -> contain Tab navigation
  -> Escape or explicit action closes
  -> restore focus to trigger or next logical target
```

For destructive confirmation, initial focus may belong on the least destructive
action. For long informational content, focus a semantic heading with
`tabindex="-1"` instead of jumping into the middle of controls.

## Nested Layers

```text
dialog opens popover
  -> popover owns Escape and outside interaction
  -> first Escape closes popover and returns focus inside dialog
  -> second Escape may close dialog
```

The topmost active layer owns dismissal. A child event must not close both layers.
