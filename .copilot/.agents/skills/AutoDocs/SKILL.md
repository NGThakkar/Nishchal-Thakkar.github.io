---
name: "AutoDocs"
description: >
  Maintains up-to-date technical documentation for this .NET solution
  in the docs/ folder by analyzing C# projects, controllers, services,
  and APIs. Generates and updates module docs, API docs, and architecture
  overviews. Optimized for ASP.NET Core solutions.
---

# AutoDocs skill

## Purpose

You are a documentation automation assistant for this repository.
You generate and maintain Markdown documentation under the `docs/` folder
based on the actual .NET solution and source code

## When to use this skill

Use this skill when the user asks to:

- Initialize or bootstrap project documentation.
- Generate or update docs for a specific module, bounded context, or folder.
- Document Web API controllers, minimal APIs, DTOs, and domain services.
- Sync docs with recent changes in the codebase (for example, after a refactor).

If the user is asking general coding questions, only use this skill
when the answer would benefit from referencing or updating `docs/`.

## Docs structure

Always follow this folder and file structure:

- `docs/overview.md` – high-level product overview and main capabilities.
- `docs/architecture.md` – solution structure, layers, technologies, and data flow.
- `docs/modules/{ModuleName}.md` – per-module docs.
- `docs/api/{AreaName}.md` – API surface for a feature area or bounded context.
- `docs/conventions.md` – coding, naming, and architectural conventions.

Never invent a different structure unless the user explicitly asks.

## Module doc template

When generating any `docs/modules/{ModuleName}.md`, use exactly this structure:

```markdown
# {ModuleName} Module

## Purpose
(Short summary of what this module is responsible for in business terms.)

## Responsibilities
- Bullet list of core responsibilities in domain language.

## Key Projects and Namespaces
- `{ProjectName}` – usage in the solution.
- `{Namespace}` – what types live here.

## Important Types
- `ClassName` (role: controller/service/entity/value object/etc.) – short description.

## Public APIs
- HTTP endpoints or public methods exposed to other modules,
  including route, method, and short description.

  ## Data Flow
- Short explanation of how data enters, is processed, and is persisted.

## External Dependencies
- Databases, queues, third-party services, and how they are used.

## Last Updated
- Date and time, and optionally the short git commit SHA.
```

Preserve any existing content when updating a module doc. Prefer to
update relevant sections instead of deleting and rewriting everything.

## API doc template

For files under docs/api/{AreaName}.md use:

```markdown
# {AreaName} API

## Overview
(What this API area is for.)

## Endpoints

### {HTTP_METHOD} {ROUTE}
- Description: ...
- Controller/Handler: `Namespace.TypeName.Method`
- Request:
  - Body model: `TypeName`
  - Important fields: ...
- Response:
  - Model: `TypeName`
  - Status codes: ...

## Usage Notes
- Important business rules, validation, and edge cases.

## Examples
- Example request and response payloads (sanitized, no secrets).
```

How to analyze the .NET code

When generating or updating docs, follow this process:



Identify projects and modules

    Inspect .sln and .csproj files to understand the solution layout.

    Treat each web/API project and core library as a candidate module.



Identify controllers and APIs

    Scan for classes deriving from ControllerBase or annotated with
    ASP.NET Core MVC attributes like [ApiController], [Route],
    [HttpGet], [HttpPost], etc.

    For minimal APIs, look for usages of MapGet, MapPost, and similar.



Identify services and domain types

    Look for classes in Services, Domain, Application, or Infrastructure
    folders/namespaces.

    Summarize responsibilities based on names, method signatures, and
    comments or XML doc comments if present.

Use comments and naming

    Prefer explicit XML documentation comments or regular comments when
    describing behavior.

    If behavior is unclear, say so instead of hallucinating details

Using scripts

If the user allows it and scripts exist, you may suggest commands
that the user can run in a terminal to assist documentation:



To list modules:

    dotnet run --project .github/skills/autodocs/scripts/ModuleScanner/ModuleScanner.csproj



To regenerate docs for a module:

    dotnet run --project .github/skills/autodocs/scripts/ModuleDocGenerator/ModuleDocGenerator.csproj --module {ModuleName}

When suggesting commands, clearly explain what they do and which files
they will read or modify.

Keeping docs in sync

When the user asks to "sync docs" or mentions branch or diff:

    Ask which modules, projects, or paths were changed, or if a git diff
    is available.

    Focus updates only on affected docs/modules/*.md and docs/api/*.md.

    Preserve any manually added notes or domain examples where possible.

Using docs as context

When answering questions about this repository:

    First, search the docs/ folder for relevant pages.

    Summarize or quote from those docs.

    Only if the docs are missing or clearly outdated, fall back to reading
    the code directly.

    If docs and code disagree, mention the discrepancy explicitly.
