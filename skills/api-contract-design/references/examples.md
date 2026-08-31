# API Contract Examples

Use these shapes as decision examples, not mandatory naming conventions.

## Error Shape

```json
{
  "type": "https://example.test/problems/validation",
  "title": "Request validation failed",
  "status": 400,
  "code": "validation_failed",
  "errors": [
    {
      "path": "email",
      "code": "invalid_format",
      "message": "Enter a valid email address."
    }
  ],
  "traceId": "00-..."
}
```

Stable `code` and `path` values support programmatic handling. Human-readable
messages may be localized or replaced without changing client logic.

## Cursor Page

```json
{
  "items": [
    { "id": "01J...", "createdAt": "2026-08-31T10:15:00Z" }
  ],
  "nextCursor": "opaque-token",
  "hasMore": true
}
```

The cursor must encode or reference the same stable ordering used by the query.
Treat cursors as opaque values in clients.

## Concurrency Update

```http
PATCH /documents/01J...
If-Match: "revision-17"
```

```http
HTTP/1.1 412 Precondition Failed
ETag: "revision-18"
```

The client must fetch or reconcile the newer representation before retrying.
