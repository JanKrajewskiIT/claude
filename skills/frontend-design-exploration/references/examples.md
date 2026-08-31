# Design Exploration Example

This example defines the expected depth, not a mandatory visual style.

## Stage 1 Proposal

### Direction

- A compact command-oriented workspace for frequent operational use.
- Strong hierarchy through typography and spacing rather than nested cards.
- Brand color reserved for selection, focus, and primary action.

### Structure

```text
page title + primary action
filter and view controls
primary working surface
contextual details panel
```

### Behavior

- Desktop keeps results and details visible together.
- Mobile opens details as a full-height surface with explicit back navigation.
- Empty, loading, error, partial, and permission-limited states preserve layout.

### Trade-offs

- Higher information density improves repeated work but needs strong focus states.
- Persistent details speed comparison but reduce width for the primary surface.

### Approval Gate

- Ask whether to preserve, revise, or reject this direction.
- Do not inspect existing primitives until the user approves Stage 2.