---
name: ace-agents-file
description: Proposes edits to the repo's AGENTS.md and CLAUDE.md files.
disable-model-invocation: true
---

# Agents file

Check the repo's `AGENTS.md` and `CLAUDE.md` against the rules below and propose edits. Done means the user has said yes, no, or what to change, and only approved edits are made.

## Constraints

- Show the edits first. Edit only after the user approves.
- Change only what a rule below asks for.
- Mark every section ace adds with `<!-- added by ace -->` on the line above it.

## Rules

- Say nothing the agent can read from the code or already knows.
- Write each instruction as the action to take. A ban ("do not X", "never X") becomes the allowed scope or the replacement action. A negation that states a fact or a condition stays.
- Say in a few sentences what the project is and who it is for.
- Say when to change files: only when the message asks for a change. A question, a report, or an idea gets an answer or a proposal.
- Say how to verify a change: the exact commands to run (lint, typecheck, tests, build) and how to check the behavior works.
- Have a short glossary of who is who:
  - "you" is always the agent.
  - "I", "me" is the person who wrote the file.
  - "we", "us", "maintainers" are the people who own the project.
  - "user" is the person using the product, not the agent's operator. Say so if it differs.
  - The project's own terms follow in the same section, one line each. Keep them there, since every session needs them. `ace-grill` adds them.

## Workflow

```
- [ ] 1. Read the files
- [ ] 2. Propose edits
- [ ] 3. Apply approved edits
```

## 1. Read the files

Read `AGENTS.md` and `CLAUDE.md` at the repo root. If both exist, note when one only points to the other. If neither exists, propose creating `AGENTS.md`.

## 2. Propose edits

For each edit, show the file, the rule it serves, and the exact text to add, change, or remove. Then stop and ask the user: yes, no, or what to change.

## 3. Apply approved edits

Make only the edits the user approved, as the user changed them.
