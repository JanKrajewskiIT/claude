---
name: design-template-app-implementation
description: Implement a complete application from a design-system template on top of an existing component library and shared packages, and align the backend contract. Use when rebuilding a product frontend from a design template, mapping template screens to features, listing previous features the design omits, or adapting APIs to a redesigned client.
---

# Design Template App Implementation

## Goal

- Deliver a working application whose screens follow the design template, built from the component library and shared packages, with the backend adapted to the new client contract.

## When To Use

- A design template defines the screens and the library already provides the components.
- A previous implementation or backend exists and its behavior must be compared with the design.

## Do Not Use

- Porting the library components themselves: use `design-system-solid-port`.
- Designing a new interface without a template: use `frontend-design-exploration`.
- One Solid component: use `solidjs-component`.
- State ownership and query design in isolation: use `solidjs-state-and-query`.
- Designing the HTTP contract in isolation: use `api-contract-design`.
- Schema changes in isolation: use `ef-core-migrations`.

## Workflow

1. Load context.
   - Read the loaded rules, the template, and the library and package documentation before writing code.
   - Read the public entry points of each shared package, such as mount, auth, i18n, and query helpers, instead of guessing their API.
   - Read sibling repositories only when the user authorized them.
2. Inventory the template.
   - Map each screen to a route, its data, its actions, and the library component that renders it.
   - Implement a custom component only when the library lacks it, and keep it faithful to the template.
3. Inventory the previous implementation from version control.
   - Write a feature matrix of kept, changed, and dropped behaviors, and the backend endpoints each used.
4. Plan the contract.
   - For each screen list its calls and classify each as existing, extended, or new.
   - Apply `api-contract-design`; keep changes additive.
5. Structure the application.
   - Create one folder per feature with its API module, action hooks, components, and dictionary.
   - Keep shared server data in one provider, domain types owned by the UI, and DTO mapping only in API modules.
   - Define each finite set and enum map once and derive guards and labels from it.
6. Build in dependency order.
   - Configuration, shell, authentication, and localization first, then the data layer, then screens, then settings.
7. Adapt the backend.
   - Carry each new field through every owning layer and register provider-specific types in every context.
   - Propose migrations and ask before generating or applying them.
   - Update the owning project documentation.
8. Verify.
   - Review statically until commands are approved.
   - Propose the project's aggregate verification script and the backend build and pending-model-changes check as exact commands.
9. Report.
   - List what was implemented, the backend changes, previous features the design omits, design features that are stored but have no effect yet, and every unrun check.

## Decision Rules

| Situation | Decision |
|---|---|
| Template needs data no endpoint provides | Extend the API additively and record it in the contract matrix. |
| Previous feature has no screen in the template | List it as omitted; do not rebuild it silently. |
| Template shows behavior with no backend yet | Persist the setting, state in the report that it has no effect, and do not fake it. |
| Typed translator rejects a library key | Use the runtime translator for library keys and the typed one for application keys. |
| Store setter rejects a readonly domain field | Type the draft with a mutable copy of the shape. |
| Parsed or imported payload carries an empty identifier | Normalize it to absent at the client mapping and at the server boundary. |

## Constraints

- Do not write or change tests unless requested.
- Do not run commands, install dependencies, or generate migrations without approval.
- Do not show raw exception text in the interface.
- Do not duplicate library components or vocabulary that the library already provides.

## Output

- Feature folders, routes, data layer, and localization.
- Backend contract changes with proposed migrations and updated documentation.
- A report of omitted previous features, ineffective design features, and unrun checks.

## Completion Criteria

- Every template screen has a route and a feature, or a recorded reason for omission.
- Every call a screen makes exists in the backend with the shape the client expects.
- Every previous feature is kept, changed, or listed as omitted.
- DTO mapping lives only in API modules, and each finite set has one definition.
- Backend changes reach every owning layer and have reviewed migrations where persistence changed.
- Unrun checks are listed with exact commands.
