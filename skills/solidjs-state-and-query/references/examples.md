# SolidJS State and Query Examples

API names differ between query libraries. Preserve the state relationships, not
the exact wrapper syntax.

## Complete Query Key

```ts
const query = createQuery(() => ({
  queryKey: ['projects', { ownerId: ownerId(), status: status() }],
  queryFn: () => getProjects({ ownerId: ownerId(), status: status() }),
  enabled: Boolean(ownerId()),
}));
```

Every normalized request input appears in the key. Reactive values are read
inside the tracked options function.

## Scoped Invalidation

```ts
queryClient.invalidateQueries({ queryKey: ['projects', project.ownerId] });
```

Invalidate the affected key family rather than the entire cache.

## Optimistic Rollback

```text
cancel matching reads -> snapshot cache -> apply optimistic value
  -> success: reconcile server value
  -> failure: restore snapshot
  -> finally: invalidate affected key
```

Do not use optimistic updates without a defined rollback snapshot.
