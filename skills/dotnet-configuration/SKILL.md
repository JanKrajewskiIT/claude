---
name: dotnet-configuration
description: Design, implement, or review configuration in .NET applications. Use when adding Options pattern types, binding configuration sections, validating startup settings, composing environment overrides, handling secrets, reloading values, or defining configuration ownership across hosts and libraries.
---

# .NET Configuration

## Goal

- Make required configuration typed, validated, and owned by the correct application boundary.
- Fail predictably before invalid settings reach runtime operations.

## Workflow

1. Identify configuration ownership.
   - Keep deployable values in the host application.
   - Let libraries define typed requirements without choosing host-specific providers.
   - Keep user preferences and business data out of application configuration.
2. Define the shape.
   - Group related values under one stable section.
   - Use explicit types, units, defaults, and nullability.
   - Avoid one large options object shared by unrelated features.
3. Bind through local conventions.
   - Reuse repository registration helpers and naming patterns.
   - Inject typed options instead of reading string keys throughout the application.
4. Validate values.
   - Validate required fields, ranges, formats, and cross-field invariants.
   - Validate at startup when the application cannot operate without the values.
   - Produce actionable errors without revealing secret values.
5. Handle secrets.
   - Load secrets from an approved provider outside source control.
   - Keep secret examples as placeholders only.
   - Avoid exposing secrets through diagnostics, serialization, or configuration dumps.
6. Decide reload behavior.
   - Use stable snapshots when mid-operation changes would be unsafe.
   - Use monitored values only when the owning component can react atomically.
   - Document settings that require restart.
7. Compose environments.
   - Keep base configuration usable and overrides minimal.
   - Treat environment variables and deployment configuration as external contracts.
   - Avoid environment-name branches when configuration can express the decision.
8. Propose validation.
   - Check valid startup, missing and malformed values, secret redaction, override precedence, and reload behavior when supported.
   - List exact commands and ask before running them unless already approved.

## Decision Rules

| Situation | Decision |
|---|---|
| Setting is required for startup | Validate it during host construction. |
| Setting changes safely at runtime | Use monitored options with an atomic consumer update. |
| Setting is secret | Resolve it from an approved secret provider. |
| Library needs a setting | Expose a typed registration contract and let the host supply it. |
| Value represents user or tenant data | Store it outside application configuration. |

## Constraints

- Do not scatter raw configuration keys through application code.
- Do not silently replace invalid required values with operational defaults.
- Do not store production secrets in tracked configuration files.
- Do not log bound options objects that may contain secrets.
- Do not assume reload semantics without verifying the provider and consumer lifetime.

## Completion Criteria

- Each setting has one owner, type, source, and validation rule.
- Required invalid configuration fails with an actionable redacted message.
- Secret handling does not depend on source-controlled values.
- Reload and restart behavior are explicit.
- Proposed checks cover binding, precedence, validation, and redaction.