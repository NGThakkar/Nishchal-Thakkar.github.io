---
name: session-memory
description: >
  Saves and restores task-specific session context between conversations so
  Copilot can resume exactly where it left off on the same task. Use when
  starting, saving, or continuing a multi-session task. Trigger: "save
  session", "resume [task]", "continue from last session", "save progress",
  "what was I working on".
user-invocable: true
disable-model-invocation: false
---

# Session Memory skill

## Purpose

1. Capture the current state of a task at the end of a conversation (or on demand) so it can be restored in a future session.
2. Restore that context at the start of a new conversation, giving Copilot full awareness of what was done, what decisions were made, and what comes next.
3. Keep session snapshots concise and actionable — not a transcript, but a structured handoff note.

Think of each session file as a shift handover: just enough for the next "shift" (session) to continue without re-explaining everything.

## When to use this skill

- The user says: "save session", "save progress", "save context", "snapshot this session", or similar.
- The user says: "resume [task]", "continue from last session", "what was I working on", "load context for [task]", or similar.
- The user is about to close VS Code or end a long conversation and wants to preserve state.
- Copilot is starting a new conversation and the user references a named task that may have a saved session.

## Inputs and outputs

- **Inputs (save)**: The task name, a summary of what was accomplished this session, decisions made, files changed, and the next steps.
- **Inputs (restore)**: The task name (or a keyword identifying the task).
- **Outputs (save)**: A session snapshot file at `/memories/session/session-{task-name}.md`.
- **Outputs (restore)**: A brief human-readable recap of the saved state, ready for Copilot to act on.

## Step-by-step instructions

### Saving a session

1. Ask the user for a short task name (e.g. `credas-scan-refactor`, `docusign-webhook`) if not already provided.  
   Use the task name to form the file path: `/memories/session/session-{task-name}.md`.

2. Gather the following from the current conversation:
   - **What was done**: A bullet list of completed actions (feature built, bug fixed, files edited).
   - **Decisions made**: Key choices and the reasoning behind them.
   - **Files changed**: Relevant file paths touched during this session.
   - **Open questions**: Anything unresolved or deferred.
   - **Next steps**: Concrete actions for the next session (in priority order).

3. Use the template at `templates/session-snapshot.md` to structure the file.

4. Write (or overwrite) `/memories/session/session-{task-name}.md` using the memory tool.

5. Confirm to the user:
   > "Session saved to `/memories/session/session-{task-name}.md`. Start your next conversation with 'resume {task-name}' to restore this context."

### Restoring a session

1. When the user says "resume [task]" or "continue from last session":
   - List `/memories/session/` to find matching session files.
   - Read `/memories/session/session-{task-name}.md`.

2. Present a concise recap:
   - What was done last session.
   - Key decisions in effect.
   - The prioritised next steps.

3. Ask the user:
   > "Shall I start with [first next step], or do you want to adjust the plan?"

4. Once the user confirms, begin executing the next steps.

5. At the end of the resumed session, offer to update the session file:
   > "Session complete. Want me to update the session snapshot with today's progress?"

## Usage examples

**Example 1 — Saving at the end of a session:**
- User: "Save session for credas-scan-refactor."
- You:
  1. Ask what was completed, decisions made, and what's next (or infer from the conversation).
  2. Write `/memories/session/session-credas-scan-refactor.md` using the snapshot template.
  3. Confirm: "Session saved. Resume with 'resume credas-scan-refactor'."

**Example 2 — Restoring at the start of a new session:**
- User: "Resume credas-scan-refactor."
- You:
  1. Read `/memories/session/session-credas-scan-refactor.md`.
  2. Recap: "Last session you refactored the scan endpoint and deferred rate-limiting. Next steps are: (1) add unit tests for ScanService, (2) wire up the rate-limit middleware."
  3. Ask: "Shall I start with the unit tests?"

**Example 3 — Mid-session snapshot:**
- User: "Save progress — I need to switch context for a bit."
- You:
  1. Summarise the conversation so far into a snapshot.
  2. Write or update `/memories/session/session-{task-name}.md`.
  3. Confirm: "Progress saved. Pick up anytime with 'resume {task-name}'."

## Agent behaviour

- **File naming**: always `session-{task-name}.md` using lowercase kebab-case.
- **Overwrite, don't append**: each save replaces the previous snapshot; the file represents the latest known state.
- **Be concise**: next steps should be actionable bullets, not paragraphs.
- **Auto-detect task name**: if the conversation has an obvious topic (e.g. a branch name, JIRA ticket, or feature name), suggest it as the task name rather than asking.
- **Warn on stale snapshots**: if the snapshot's `Last updated` date is more than 7 days old, mention it when restoring.
- **Link to auto-memory**: if a decision is broadly applicable across sessions (a project rule, naming convention, etc.), suggest also adding it to `memory.md` via the `auto-memory` skill.

## Notes and limitations

- Session files live under `/memories/session/` which is conversation-scoped storage — they persist between conversations but are logically treated as temporary working state.
- If no session file exists for the requested task, say so clearly and offer to create a new one.
- Do not include sensitive values (tokens, passwords, connection strings) in session snapshots.
