---
name: mkdocs-documentation
description: Create, review, or maintain standalone MkDocs Material documentation built and served from its own container. Use when changing project documentation, MkDocs navigation, Mermaid diagrams, documentation Dockerfiles, local documentation serving, or deployment routing for the documentation site.
---

# MkDocs Documentation

## Goal

- Produce trustworthy project documentation that builds as a standalone MkDocs Material site and remains aligned with code, configuration, architecture, and operations.

## Workflow

1. Inspect repository instructions, `docs/mkdocs.yml`, `docs/docs/`, `docs/Dockerfile`, local orchestration, deployment routing, and the implementation being documented.
2. Document a change only when it alters a user or operator contract, domain behavior, interface, architecture, integration, significant configuration, or operational procedure.
3. Identify the audience and question.
   - Update the canonical page when one exists; otherwise choose the smallest suitable type from [`references/mkdocs-reference.md`](references/mkdocs-reference.md).
4. Derive claims from source code, executable configuration, schemas, tests, and verified runtime behavior.
   - Link canonical specifications and runbooks instead of copying volatile values.
5. Keep implemented behavior in canonical pages and separate requirements, architecture, technical guidance, runbooks, and external-system notes according to the existing navigation model.
6. Use only Markdown extensions and plugins enabled in `mkdocs.yml`.
   - Prefer Mermaid for reviewable diagrams and include a short textual interpretation.
7. Add every maintained page to explicit `nav`, preserve working relative links, and keep headings suitable for stable anchors.
8. Keep the documentation container reproducible.
   - Pin compatible tool ranges, copy only documentation inputs, run as a non-root user, expose the documented port, and retain a useful healthcheck.
9. Keep local orchestration, container port, public route, proxy configuration, and documented URLs consistent.
10. Propose the narrowest documentation build, container, link, and route checks without starting processes unless explicitly authorized.

## Authoring Rules

- Start each page with its purpose and organize it around reader tasks and decisions.
- Use one canonical term per concept, short sections, compact tables, and numbered procedures.
- Put prerequisites before commands and expected results after them.
- Use verified environment names and URLs and keep changing values behind canonical links.
- Include only purposeful current images with meaningful alt text and no sensitive data.
- Mark deprecated behavior with replacement, migration path, and removal condition.
- Never publish secrets, credentials, personal data, or unredacted incident data.

## Build And Deployment Rules

- Keep `mkdocs.yml` and Markdown sources inside the documentation build context.
- Declare every required MkDocs theme, plugin, and extension in the container build.
- Treat plugin names, extension configuration, source paths, navigation, container port, healthcheck, and proxy target as one compatibility contract.
- Keep documentation deployment independent of developer-only files, undeclared Python packages, and workstation state.
- Use the existing reverse proxy and deployment conventions instead of adding a second publication mechanism.

## Completion Criteria

- Readers can find purpose, architecture, technical guidance, business behavior, runbooks, and external dependencies through navigation.
- Canonical claims match implementation and executable configuration.
- Every page is reachable and every relative link resolves.
- Enabled diagrams and Markdown features match `mkdocs.yml` and declared container dependencies.
- The container runs without root privileges and exposes the expected health and serving port.
- Local and deployed routes identify the same documentation site without introducing another source of truth.

## Constraints

- Do not introduce catalog entities, portal-specific metadata, or a second documentation platform.
- Do not invent architecture, ownership, SLOs, URLs, incident causes, or API behavior.
- Do not create pages for changes with no reader-facing or operational consequence.
- Do not add plugins or extensions merely for presentation novelty.
- Do not build images, start servers, install dependencies, or deploy documentation without explicit authorization.
