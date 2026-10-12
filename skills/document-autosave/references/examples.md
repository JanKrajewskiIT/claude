# Document Autosave Examples

## Save Contract

```ts
type SaveRequest<TDocument> = {
  document: TDocument;
  localRevision: number;
  expectedServerRevision: string;
};

type SaveResult = {
  acknowledgedLocalRevision: number;
  serverRevision: string;
  savedAt: string;
};
```

Mark the document clean only when `acknowledgedLocalRevision` equals the latest
local revision. A successful response for revision 4 must not mark revision 5 as
saved.

## Conflict Result

```ts
type SaveConflict<TDocument> = {
  kind: 'conflict';
  expectedServerRevision: string;
  actualServerRevision: string;
  localDocument: TDocument;
  remoteDocument: TDocument;
};
```

Keep both versions available for an explicit overwrite, discard, or merge
decision. Do not place conflicts into an automatic retry loop.

## Sequencing Example

```text
edit 4 -> save 4 starts -> edit 5 -> save 4 succeeds -> save 5 starts
```

After save 4 succeeds, the UI remains dirty or saving because revision 5 has not
been acknowledged.
