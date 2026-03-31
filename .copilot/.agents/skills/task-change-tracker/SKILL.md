---
name: task-change-tracker
description: >
  Tracks all Git commits and file changes related to a named task or ticket (by branch name,
  commit keyword, or task ID) and outputs a structured Markdown change summary ready to paste
  into a user manual or changelog. Use when you want to document what changed for a specific task.
  Trigger: "track changes for [task]".
version: 1.0.0
author: "Nishchal"
license: "MIT"
---

# Purpose

Given a task name, ticket ID, or branch name, collect every Git commit and changed file
associated with that task across the open workspace repos, then produce a concise, structured
Markdown summary that can be embedded directly in a user manual or release note.

# When to use this skill

Load this skill when the user says something like:

- "track changes for [task]"
- "summarise changes for [task/branch/ticket]"
- "what changed in [feature/branch]"
- "generate a change summary for [task]"
- "show me all commits for [task]"
- "build a changelog entry for [task]"

# Inputs and outputs

**Inputs:**
- Task name / ticket ID / branch name — provided by the user in the trigger phrase
- One or more repository paths (defaults to all open workspace folders)
- Optional: date range (`--since`, `--until`) if the user provides one
- Optional: author filter (defaults to all authors)

**Outputs:**
- A Markdown change summary written to `docs/change-summaries/[task-slug].md`
  inside the relevant project folder, or shown inline if the user has not specified a location.
- Uses `templates/task-changes-summary.md` as the structure.

# Step-by-step instructions

Follow these steps every time the user triggers this skill.

## Step 1 — Parse the task identifier

Extract the task token from the user's message:

- If it looks like a branch (`feature/...`, `fix/...`, `release/...`) → treat as **branch name**.
- If it matches a ticket pattern (e.g. `BTL-123`, `KS-45`) → treat as **ticket ID keyword**.
- Otherwise → treat as a **free-text keyword** to grep in commit subjects.

Ask for clarification only if the token is completely ambiguous and cannot be resolved with Step 2.

## Step 2 — Locate relevant commits

Run in each applicable repo.

**Option A – branch-based lookup:**
```bash
git -C <repo-path> log <branch-name> --not $(git -C <repo-path> merge-base <branch-name> main)^@ \
  --format="%H|%an|%ad|%s" --date=short
```
If `main` does not exist, try `master` or `develop`.

**Option B – keyword search across all branches:**
```bash
git -C <repo-path> log --all --grep="<task-token>" \
  --format="%H|%an|%ad|%s" --date=short
```

Collect all matching lines. Deduplicate by commit hash.

## Step 3 — Collect changed files per commit

For each unique commit hash from Step 2:
```bash
git -C <repo-path> show --stat --no-patch <hash>
```

Build a flat list of all unique file paths touched across all commits for this task.

## Step 4 — Categorise the changes

Group commits and files using this table:

| Category      | Commit keywords / file signals                                    |
|---------------|-------------------------------------------------------------------|
| **Feature**   | `feat`, `add`, `new`, `implement`, `create`, `introduce`          |
| **Fix**       | `fix`, `bug`, `error`, `resolve`, `patch`, `correct`             |
| **Refactor**  | `refactor`, `clean`, `rename`, `move`, `restructure`             |
| **Chore**     | `chore`, `config`, `update`, `bump`, `upgrade`, `deps`, `build`  |
| **Docs**      | `docs`, `readme`, `comment`, `document`, `manual`                |
| **Other**     | anything that does not fit the above                             |

A single commit may appear under multiple categories if it touched different areas.

## Step 5 — Draft the Markdown summary

Use `templates/task-changes-summary.md` as the structure. Fill in:

- **`[Task]`** — the task name as supplied by the user.
- **`[Date Range]`** — earliest commit date → latest commit date.
- **`[Repo]`** — repository name (repeat section per repo if multiple).
- **Commit table** — one row per commit: date, author, message.
- **Changed files** — grouped by category from Step 4.
- **Summary prose** — 2–4 plain-English sentences describing what was built or changed,
  written at a level suitable for a user manual author to understand without reading code.

## Step 6 — Write the output file

Determine the target location:

1. If there is a `docs/change-summaries/` folder in the repo → write there.
2. Otherwise create `docs/change-summaries/` and write the file.
3. Name the file using the task slug (lowercase, hyphens): `[task-slug].md`.

Show the user the full path of the written file and the first 30 lines of the content.

## Step 7 — Offer to link with user-manual skill

After writing the file, ask:

> "Would you like me to use the **user-manual** skill to turn this change summary
> into a full client-facing user manual?"

If yes, hand control to the `user-manual` skill, passing the generated summary as
the task description.

# Usage examples

**Example 1 — branch-based:**
- User: "track changes for feature/docusign-integration"
- You:
  1. Run branch log vs `main` in each open repo.
  2. Collect files changed across all commits on that branch.
  3. Categorise as Feature / Fix / Chore.
  4. Write to `docs/change-summaries/docusign-integration.md`.
  5. Offer to feed into user-manual skill.

**Example 2 — ticket ID:**
- User: "track changes for BTL-204"
- You:
  1. `git log --all --grep="BTL-204"` across all repos.
  2. Collect all matching commits and their changed files.
  3. Categorise and draft summary including Feature (new upload endpoint) and Fix (validation error).
  4. Write to `docs/change-summaries/btl-204.md`.

**Example 3 — free-text task name:**
- User: "track changes for loan completion screen"
- You:
  1. Grep commits for "loan completion" across repos.
  2. If no results, ask the user for the branch name or ticket ID to narrow the search.
  3. Proceed from Step 3 once commits are found.

# Notes and limitations

- Commits on squash-merged branches may not be visible via `--grep`; branch-based lookup
  (Option A, Step 2) is more reliable for such workflows.
- This skill only reads Git metadata — it does not read code or diff content to infer
  business meaning. The summary prose is derived from commit subjects and file paths.
- If the user wants richer descriptions, suggest feeding the output into the `user-manual` skill.
- Cross-repo tasks are fully supported: the summary groups changes by repo.
