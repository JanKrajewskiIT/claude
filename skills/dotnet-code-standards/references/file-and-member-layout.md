# File And Member Layout

## Enforced By Tools

| Standard                                        | Rule                    |
| ----------------------------------------------- | ----------------------- |
| Braces on every control-flow body               | IDE0011                 |
| Opening and closing braces on their own lines   | IDE0055                 |
| File-scoped namespace                           | IDE0161                 |
| Namespace matches folder                        | IDE0130                 |
| Usings outside the namespace, no unused usings  | IDE0065, IDE0005        |
| No consecutive blank lines                      | IDE2000                 |
| Blank line after a block before a statement     | IDE2003                 |
| No blank line between consecutive braces        | IDE2002                 |
| Blank line between members                      | SA1516                  |
| One top-level type per file                     | SA1402                  |
| File name matches the first type                | SA1649                  |
| Member order by kind and accessibility          | SA1201, SA1202, SA1204  |
| Naming                                          | IDE1006                 |

## Files And Types

- Put one class, interface, struct, or record in one file named after it.
- Group data-only types of one capability, such as DTOs, contract records, and integration events, in one file named `<Capability>Contracts.cs` or `<Capability>Models.cs`.
- Put an enum in its own file unless it is used only by types in a `*Contracts.cs` or `*Models.cs` file.
- Do not group types that contain behavior, dependencies, or more than trivial computed members.
- Keep nested types only when they are private implementation details of the parent.
- Name a file containing a generic type after the type without its type parameters.

## Member Order

1. Constants.
2. Static fields.
3. Instance fields.
4. Constructors.
5. Properties.
6. Public methods.
7. Internal and protected methods.
8. Private methods.
9. Nested types.

Within each group, order members by accessibility: public, internal, protected, private.
Keep an overload set together.

## Spacing

- Separate members with exactly one blank line.
- Separate a block from the following statement with one blank line.
- Separate logical steps inside a method with one blank line; do not insert blank lines between every statement.
- End each file with one newline.

## Readability

Enforced by tools:

- No `#region` blocks (SA1124).
- Trailing comma after the last element of a multi-line initializer or collection (SA1413).
- Attribute on its own line, not on the line of the element (SA1134).

Applied by hand, because no tool wraps code:

- Keep lines within 120 characters.
- Keep up to two parameters or arguments on one line when the line fits the limit.
- Put each parameter or argument on its own line when there are three or more, in declarations, primary constructors, constructors, and calls.
- Put each parameter or argument on its own line when two do not fit the limit.
- Do not split parameters across lines in any other pattern (SA1116 and SA1117 report mixed layouts).
- Put each call of a method chain longer than two calls on its own line, with the dot leading the line.
- Wrap a multi-line condition so each `&&` or `||` operand starts its own line.
- Prefer a named local or a small private method over a nested expression that needs wrapping.

## Naming

- Use PascalCase for types, members, and constants.
- Use `I` plus PascalCase for interfaces.
- Use `_camelCase` for private fields.
- Use camelCase for parameters and locals.
- Use the `Async` suffix on methods that return `Task` or `ValueTask`, except endpoint and handler entry points whose name is fixed by a framework contract.
- Name a use-case type after the use case: `CreateOrderCommand`, `CreateOrderHandler`, `CreateOrderValidator`, `GetOrderQuery`, `OrderResponse`.
