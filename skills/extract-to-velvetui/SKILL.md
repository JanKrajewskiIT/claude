---
name: extract-to-velvetui
description: Evaluate and execute extraction of reusable frontend patterns from a VelvetUi consumer app into the library without leaking product-specific logic.
---

Normative constraints: `project-core`, `solidjs-tsx`, `css-modules`, `i18n`, `velvet-consumer-frontend`, `extraction-boundary`.

## Decision workflow

1. Identify what's truly reusable: visual primitive, workflow shell, hook, utility, or just a local app adapter
2. Separate domain behavior from generic interaction behavior
3. Keep app-specific queries, mutations, models, route state, and copy ownership in the consumer app unless the text is generic library copy
4. Rename the extracted API to neutral semantics before moving code
5. Recompose the original app feature on top of the new VelvetUi export

## Good candidates

- Reusable form shells and field group layouts
- Generic overlays, editor shells, selection widgets, timelines, boards, preview scaffolds
- Shared query/store helpers not tied to one business domain
- Typed utility functions and primitive interaction hooks

## Bad candidates

- Components whose props are mostly domain nouns from the source app
- Anything owning API requests, invalidation rules, OIDC-specific decisions, or product-specific workflows
- UI that only becomes reusable after adding many escape hatches

## Before finishing

- Read the resulting public API as if you had never seen the source app
- Confirm the consumer-app call site became simpler, not more contorted
- Library export wired through `src/index.ts` and remains semantically neutral
