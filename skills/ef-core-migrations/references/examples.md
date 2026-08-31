# EF Core Migration Examples

## Preserve Data During Rename

```csharp
migrationBuilder.RenameColumn(
    name: "Name",
    table: "Customers",
    newName: "FullName");
```

Use an explicit rename when the old and new properties represent the same data.
Generated drop-and-add operations would discard existing values.

## Staged Backfill

```text
1. Add the destination column as nullable.
2. Deploy code that can read both representations when overlap is required.
3. Backfill existing rows in bounded batches.
4. Verify completeness.
5. Make the destination required.
6. Remove the source column in a later migration.
```

Separate releases may be required for large tables or rolling deployments.

## Deployment Choice

```powershell
dotnet ef migrations script --idempotent --output artifacts/migrations.sql
dotnet ef migrations bundle --output artifacts/efbundle.exe
```

These are proposed commands only. Ask before running them. Prefer a script when
SQL review is required and a bundle for controlled automated execution.
