# Aspire Composition Examples

Verify APIs against the installed Aspire version before applying these shapes.

## Service and Database

```csharp
var postgres = builder.AddPostgres("postgres");
var catalogDatabase = postgres.AddDatabase("catalog-db");

builder.AddProject<Projects.Catalog_Api>("catalog-api")
    .WithReference(catalogDatabase)
    .WaitFor(catalogDatabase)
    .WithHttpHealthCheck("/health");
```

`WithReference` supplies connection information. `WaitFor` is justified only
when startup requires dependency readiness.

## Secret Parameter

```csharp
var apiKey = builder.AddParameter("external-api-key", secret: true);

builder.AddProject<Projects.Worker>("worker")
    .WithEnvironment("ExternalApi__ApiKey", apiKey);
```

The parameter represents a secret boundary; its value does not belong in source.
