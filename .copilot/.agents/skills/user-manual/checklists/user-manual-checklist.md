# User Manual Creation Checklist

Use this checklist every time you create a user manual to ensure completeness and quality.
Work through each section in order before saving the final file.

---

## Phase 1 — Information gathering

- [ ] Task name confirmed (short, plain-English, e.g., "Submit Loan Application")
- [ ] File name slug derived (lowercase with hyphens, e.g., `submit-loan-application.md`)
- [ ] Task description received from the user
- [ ] Affected systems identified:
  - [ ] `backoffice`
  - [ ] `frontend`
  - [ ] `bridgingapi`
  - [ ] `credasscanapi`
  - [ ] `docusignapi`
  - [ ] `btlapi`
  - [ ] Other: ___________
- [ ] Specific files or screens identified (if provided by user)

---

## Phase 2 — Code exploration

### Backoffice / Frontend
- [ ] Relevant `.aspx` pages located and read
- [ ] Code-behind (`.aspx.cs`) read for button actions, validation, and redirects
- [ ] All button labels, field names, and screen names extracted exactly as shown in UI
- [ ] Validation and error messages noted (user-visible text only)
- [ ] Success/confirmation messages noted
- [ ] Navigation flow understood (entry point → task → exit point)

### APIs (if applicable)
- [ ] Relevant API controller(s) read
- [ ] User-facing behaviour extracted (what the user triggers, what the user sees)
- [ ] All technical terms translated to plain English
- [ ] No API endpoint names, HTTP methods, or status codes included in draft

### Business rules
- [ ] Required fields and eligibility conditions understood
- [ ] Status transitions noted (e.g., Draft → Submitted)
- [ ] Automated side-effects noted (e.g., email sent, document generated)

---

## Phase 3 — Drafting quality checks

- [ ] Template used: `templates/task-manual-template.md`
- [ ] Title and metadata filled in (Version, Last Updated, Applies To)
- [ ] **Overview** section: 1–2 plain-English sentences, no jargon
- [ ] **Before You Begin** section: all prerequisites and permissions listed
- [ ] Every user action is written as a **numbered step**
- [ ] All button names, field names, and screen names are **bolded** and match the UI exactly
- [ ] Screenshot placeholders added at every key point with descriptive captions
- [ ] **What Happens Next** section explains the system response after completion
- [ ] **Common Issues** table populated with at least 1–2 realistic problems
- [ ] **Tips** section includes at least 1 useful tip
- [ ] No technical jargon: no class names, method names, API names, HTTP terms, or DB field names

### Language checks
- [ ] Written in second person ("You will see…", "Click **Submit**…")
- [ ] Sentences are short and direct
- [ ] Persona is correct:
  - Backoffice → back-office agent / loan officer / administrator
  - Frontend → applicant / borrower / client

---

## Phase 4 — Review and save

- [ ] Complete draft shown to user
- [ ] User feedback incorporated
- [ ] Final file path confirmed:
  - Backoffice: `d:\Project\GIT\kseye\backoffice\docs\user-manuals\[task-name].md`
  - Frontend: `d:\Project\GIT\kseye\frontend\docs\user-manuals\[task-name].md`
- [ ] File name is lowercase with hyphens
- [ ] File created in the workspace
