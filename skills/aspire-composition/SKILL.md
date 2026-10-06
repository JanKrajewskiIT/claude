---
name: aspire-composition
description: Add, connect, or review resources in a .NET Aspire distributed application. Use when modifying an AppHost, adding services, databases, caches, containers, parameters, health checks, service references, startup dependencies, or deployment-facing resource configuration.
---

# Aspire Composition

## Goal

- Compose observable local and deployment-ready resources without hardcoded topology.
- Preserve the Aspire and hosting conventions used by the repository version.

## Workflow

1. Inspect the distributed application.
   - Identify the AppHost, service-defaults project, resource names, package versions, and deployment target.
   - Find a neighboring resource with the closest lifecycle and dependency shape.
2. Define the resource contract.
   - Record resource name, owner, endpoints, dependencies, health signal, configuration, and persistence needs.
   - Decide whether configuration is public, environment-specific, or secret.
3. Add the resource.
   - Use the resource builder supported by the installed Aspire version.
   - Keep logical resource names stable and independent of machine addresses.
4. Connect dependencies.
   - Use resource references or service discovery instead of hardcoded hosts and ports.
   - Add startup ordering only when readiness is required before the dependent starts.
   - Bind generated connection information through the application's configuration system.
   - Use [`references/examples.md`](references/examples.md) for representative resource relationships.
5. Configure health and observability.
   - Reuse service defaults for health checks, telemetry, resilience, and discovery.
   - Expose a health signal that represents actual readiness when dependencies matter.
6. Handle parameters and secrets.
   - Represent secrets with the platform's secret parameter mechanism or external secret store.
   - Do not commit secret values or place them in logs, source, or generated artifacts.
7. Update external routing when required.
   - Keep gateway routes, API discovery, CORS, and authentication boundaries aligned with the new endpoint.
8. Validate.
   - Propose starting the AppHost with the repository-native command.
   - Ask before running commands unless the current request already grants permission.
   - Confirm resource health, dependency resolution, endpoint reachability, logs, and clean shutdown.
   - Propose deployment generation or publish checks when deployment configuration changed.

## Decision Rules

| Need | Preferred mechanism |
|---|---|
| Discover another service | Resource reference and service discovery |
| Delay startup until dependency readiness | Explicit wait dependency |
| Pass a credential | Secret parameter or external secret store |
| Share telemetry and resilience defaults | Service-defaults project |
| Persist local infrastructure data | Resource volume or repository convention |

## Constraints

- Verify version-sensitive APIs against current Aspire documentation or installed package APIs.
- Do not encode generated ports, container names, or local machine paths as application contracts.
- Do not add waits where runtime resilience should handle temporary unavailability.
- Do not expose infrastructure resources publicly without an explicit requirement.

## Completion Criteria

- Every resource has a stable name and explicit dependency relationships.
- Applications resolve dependencies without hardcoded network locations.
- Secrets remain outside source control and observable output.
- Health and telemetry expose useful startup or runtime failures.
- Local orchestration and affected deployment checks pass or are reported as unrun with exact commands.
