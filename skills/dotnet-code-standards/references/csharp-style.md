# C# Style

## Types

- Seal classes that are not designed for inheritance.
- Give types the narrowest visibility callers allow; default to `internal` inside an application project.
- Use `record` for immutable data carriers such as commands, queries, results, and DTOs.
- Use a class for types with identity, mutable state, or dependencies.
- Use a primary constructor for every class and struct whose constructor only receives values or dependencies (IDE0290 reports the rest).
- Keep an explicit constructor only when it validates arguments, runs logic, or declares more than one constructor.
- Do not reassign a primary constructor parameter; copy it to a `readonly` field when the value must change or be validated.
- Use `required` and `init` for data types with more than three members instead of long positional records.

## Members

- Use expression bodies for properties, accessors, and lambdas; use block bodies for methods and constructors.
- Mark fields `readonly` when they are not reassigned.
- Return early with guard clauses instead of nesting the main path.
- Keep methods under one screen; extract a named private method when a block needs a comment to explain what it does.

## Expressions

- Use `var` everywhere.
- Use collection expressions for collection literals.
- Use `switch` expressions and pattern matching for value mapping instead of `if` chains.
- Use LINQ for projections and filters; use loops when the body has side effects or early exit.
- Do not materialize a sequence twice; call `ToList` or `ToArray` once when it is enumerated more than once.

## Nullability And Async

- Express absence with nullable annotations; do not use the null-forgiving operator to silence a real possibility.
- Return `Task` or `ValueTask` through the full chain; do not block with `.Result` or `.Wait()`.
- Accept `CancellationToken` as the last parameter and pass it to every cancellable call.

## Failures

- Follow the repository error-handling rule for exceptions versus result types.
- Do not catch `Exception` except at a host boundary that logs and maps it.
