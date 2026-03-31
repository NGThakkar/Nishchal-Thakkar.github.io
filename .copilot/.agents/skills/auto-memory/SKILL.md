---
name: auto-memory
description: >
  A background skill that generates and maintains memory.md with project
  rules, conventions, and gotchas, and encourages Copilot to consult it.
user-invocable: true
disable-model-invocation: false
---

# Auto Memory skill

## Purpose

1. Capture project knowledge from conversations, code changes, and user input without manual doc writing.  
2. Keep `memory.md` up to date as the codebase and workflows evolve.  
3. Encourage Copilot agents and humans to consult `memory.md` before answering questions about this project.

Treat `memory.md` as the single source of truth for project rules and quirks.

## When to use this skill

- The user says: “update memory”, “remember this”, “add this to memory.md”, or similar.  
- The user describes a new pattern, naming convention, architecture rule, or gotcha that should be remembered.  
- Copilot notices that a suggestion contradicts an existing rule in `memory.md`.

## Workflow

1. When the user asks to update memory or describes a new rule:
   - Open `memory.md` in the repository root (create it if needed).
   - Identify the appropriate section:
     - `## Architecture`
     - `## Naming conventions`
     - `## Coding patterns`
     - `## Gotchas / deprecations`
     - or create the section if it doesn’t exist.
2. Summarize the new information as one or more short, rule‑like sentences, for example:
   - “Use ExportService for exports, never LegacyExportService.”
   - “Backend validates DTOs; frontend validation is for UX only.”
3. Insert or update the rule in the correct section:
   - Avoid duplicating existing bullets.
   - If a previous rule conflicts, update or remove it instead of adding a second, contradictory rule.
4. After editing `memory.md`:
   - Show the user the diff or the updated section.
   - Propose a commit message such as:
     - “Update memory.md: add export deprecation rule.”
5. Remind the user that other Copilot agents should read `memory.md` before answering questions about this project.

## Examples

- User: “Update memory to say exports must always go through ExportService, never LegacyExportService.”
  - Action:
    - Add a bullet under `## Gotchas / deprecations`:
      - “Use ExportService for exports; do not use LegacyExportService.”
    - Suggest a commit message:
      - “Update memory.md: export service rule.”

- User: “Summarize what we decided about validation this week.”
  - Action:
    - Read recent discussion and relevant diffs if available.
    - Add under `## Coding patterns`:
      - “Backend performs all authoritative DTO validation; frontend validation is for UX only.”

- User: “Update memory to prefer PascalCase for C# types and React components.”
  - Action:
    - Under `## Naming conventions`, add or update bullets describing PascalCase rules.

## Agent behavior

You are the auto‑memory agent for this repository.

- Always try to keep `memory.md` **concise and readable**.  
- Prefer updating existing bullets over adding near‑duplicates.  
- If the user’s request contradicts a rule already in `memory.md`, ask:
  - “This contradicts an existing rule in memory.md. Do you want to update that rule ins