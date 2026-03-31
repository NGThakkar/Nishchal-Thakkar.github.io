---
name: daily-log
description: >
  Generates a structured Markdown daily log entry based on your Git activity for the current day.
  Use when you want to write or update your developer daily log from today's commits, diffs, and changed files.
  Only includes commits authored by you, auto-detected via git config.
version: 1.0.0
author: "Nishchal"
license: "MIT"
---

# Purpose

Help the user write a structured Markdown daily log entry by analysing all Git commits and file changes they authored today across one or more repositories, then appending a formatted entry to a `DAILYLOG.md` file.

# When to use this skill

Load this skill when the user says something like:

- "write my daily log"
- "log today's changes"
- "update my daily log"
- "what did I work on today"
- "generate daily log"
- "add today's work to my log"
- "summarise what I did today"

# Inputs and outputs

- **Inputs:**
  - One or more Git repository paths (defaults to all open workspace folders)
  - Git author identity (auto-detected via `git config user.name` and `git config user.email`)
  - Today's date (auto-detected from the system)
  - Target log file (defaults to `DAILYLOG.md` in each repo root; ask the user if ambiguous)

- **Outputs:**
  - A new dated Markdown section appended to `DAILYLOG.md` for each active repo

# Step-by-step instructions

Follow these steps every time the user asks to create or update a daily log.

## Step 1 — Identify repos and author

1. List all open workspace folder paths.
2. In each folder, confirm it is a Git repo and detect the author:
   ```
   git -C <repo-path> rev-parse --is-inside-work-tree
   git -C <repo-path> config user.name
   git -C <repo-path> config user.email
   ```
3. Use the name returned as the `--author` filter in all subsequent commands.

## Step 2 — Collect today's commits

Run in each repo:
```
git -C <repo-path> log --since="midnight" --until="now" --author="<name>" --format="%H|%s|%ad" --date=short
```

Output format per line: `<commit-hash>|<subject>|<date>`

If no commits exist for today, note the repo as "no commits today" and still proceed to Step 3 to check for uncommitted changes.

## Step 3 — Collect changed files

For each commit hash from Step 2:
```
git -C <repo-path> show --stat --no-patch <hash>
```

Also check for any staged or unstaged uncommitted work:
```
git -C <repo-path> diff --stat HEAD
git -C <repo-path> diff --cached --stat
```

If uncommitted changes exist, list them separately under an **"In Progress"** section in the log entry.

## Step 4 — Categorise the changes

Group changes by scanning commit message subjects and file paths:

| Category     | Keywords / signals                                          |
|--------------|-------------------------------------------------------------|
| **Feature**  | `feat`, `add`, `new`, `implement`, `create`, `introduce`   |
| **Fix**      | `fix`, `bug`, `error`, `resolve`, `patch`, `correct`       |
| **Refactor** | `refactor`, `clean`, `rename`, `move`, `restructure`       |
| **Chore**    | `chore`, `config`, `update`, `bump`, `upgrade`, `deps`     |
| **Docs**     | `docs`, `readme`, `comment`, `document`                    |
| **Other**    | anything that does not fit the above                       |

A single commit may produce multiple bullets if it touched files across categories.

## Step 5 — Draft the log entry

Use `templates/daily-log-entry.md` as the structure. Fill in:

- Today's date as the top-level heading: `## DD MMM YYYY`
- One repo per sub-section (`### <Repo Name>`)
- Bullet points grouped by category
- A short 1–2 sentence summary paragraph at the very top of the entry

Show the full draft to the user and ask:
> "Does this look right? Any additions or corrections before I save it?"

## Step 6 — Save the log

Once the user confirms:

1. Check if `DAILYLOG.md` exists in the repo root.
   - If it does **not** exist, create it with the title:
     ```markdown
     # Developer Daily Log
     ```
2. Check if a section for today's date already exists in the file.
   - If it **does** exist, append the new content under the existing date heading rather than duplicating the heading.
   - If it does **not** exist, append the new section at the bottom of the file.
3. Do **not** overwrite or delete any existing log content.
4. Confirm the saved file path to the user.

# Usage examples

**Example 1 — Single repo, end-of-day log**
- User: "Write my daily log for today."
- You:
  1. Detect open workspace repos.
  2. Run `git log --since="midnight" --author="Nishchal"` — finds 3 commits.
  3. Categorise: "Add loan calculator endpoint" → Feature; "Fix null reference in mapper" → Fix; "Refactor service layer" → Refactor.
  4. Collect changed files via `git show --stat` for each commit.
  5. Draft entry under `## 18 Mar 2026` with sub-heading `### bridgingapi`.
  6. Show draft, wait for confirmation.
  7. Append to `d:\Project\GIT\kseye\bridgingapi\DAILYLOG.md`.

**Example 2 — Multi-repo log**
- User: "Log today's changes across all my projects."
- You:
  1. Detect all open workspace repos (bridgingapi, credasscanapi, docusignapi, etc.).
  2. Run git commands in each; skip repos with no activity today.
  3. Combine active repos under a single `## 18 Mar 2026` heading, one `###` sub-section per repo.
  4. Show the combined draft and confirm with the user.
  5. Append to each repo's own `DAILYLOG.md`.

**Example 3 — Partial day with uncommitted work**
- User: "Update my daily log."
- You:
  1. Find 1 commit + uncommitted staged changes.
  2. Include committed work under the appropriate categories.
  3. List uncommitted changes under a separate **In Progress** bullet.
  4. Note: "You have uncommitted changes — these are listed as in-progress but not committed yet."

# Notes and limitations

- Only your commits are included. The `--author` filter is based on the `user.name` value from `git config` in each repo. If your name differs between repos, the skill resolves it per repo automatically.
- Uncommitted work-in-progress is noted separately in the log — it is not attributed to any commit.
- The skill does not commit or push `DAILYLOG.md`. That remains the user's responsibility.
- Repos with no activity today are silently skipped unless the user explicitly asks to include them.
- For very large diffs, only the `--stat` summary (file names and line counts) is used rather than the full diff body.
- If a date heading already exists in `DAILYLOG.md`, new content is appended under it without duplicating the heading.
