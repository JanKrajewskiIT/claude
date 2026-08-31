# NuGet Library Examples

## SDK Package Metadata

```xml
<PropertyGroup>
  <TargetFramework>net10.0</TargetFramework>
  <PackageId>Example.Text</PackageId>
  <Description>Text processing primitives for .NET applications.</Description>
  <Authors>Example</Authors>
  <PackageLicenseExpression>MIT</PackageLicenseExpression>
  <RepositoryUrl>https://example.test/repository</RepositoryUrl>
  <RepositoryType>git</RepositoryType>
  <PublishRepositoryUrl>true</PublishRepositoryUrl>
  <IncludeSymbols>true</IncludeSymbols>
  <SymbolPackageFormat>snupkg</SymbolPackageFormat>
</PropertyGroup>
```

Use repository-owned versioning when versions are set centrally. Select target
frameworks from real consumer requirements rather than copying this example.

## Private Build Dependency

```xml
<PackageReference Include="Example.Generator" Version="1.2.3"
                  PrivateAssets="all" />
```

Do not mark a runtime dependency private merely to reduce transitive references.
