# Vertical Slice Examples

## Responsibility Boundary

```csharp
public sealed record RenameProjectCommand(Guid ProjectId, string Name);

public static async Task<IResult> RenameProject(
    Guid projectId,
    RenameProjectRequest request,
    ICommandHandler<RenameProjectCommand> handler,
    CancellationToken cancellationToken)
{
    await handler.Handle(new(projectId, request.Name), cancellationToken);
    return Results.NoContent();
}
```

The endpoint owns transport mapping. The handler owns loading the project,
enforcing use-case rules, changing the model, and saving it.

## Query Projection

```csharp
var result = await db.Projects
    .AsNoTracking()
    .Where(project => project.Id == query.ProjectId)
    .Select(project => new ProjectResponse(project.Id, project.Name))
    .SingleOrDefaultAsync(cancellationToken);
```

Project directly to the response when no domain behavior is required. Do not
return the tracked entity through the API.
