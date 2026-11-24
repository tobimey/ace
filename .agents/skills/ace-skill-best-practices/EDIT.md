# Edit a skill

Done means the requested behaviour is an instruction the agent must follow, the skill passes [CHECKLIST.md](CHECKLIST.md), and the report is filled in. Follow the Authoring section and the Constraints of [SKILL.md](SKILL.md) throughout.

- Keep the skill's purpose and features as they are, plus what the user asked for.
- Keep the skill's voice. Rewrite it only where it is bloated or inconsistent.

## Workflow

```
- [ ] 1. Locate the skill folder
- [ ] 2. Read SKILL.md and every file it links
- [ ] 3. Gate: purpose, triggers, requested change
- [ ] 4. Diagnose the requested change
- [ ] 5. Audit against CHECKLIST.md
- [ ] 6. Edit (behaviour first, then tightness)
- [ ] 7. Re-audit the written files
- [ ] 8. Report
```

### 1. Locate

Use the skill the user named, attached, or has open. Search the project's and the user's skill folders if needed. Folder name must match frontmatter `name`. If several match, ask which one.

### 2. Read

Read `SKILL.md` fully. Read every file it links (one level). List `scripts/` and note whether the body says **run** or **read**.

### 3. Gate: purpose, triggers, requested change

Before any edit, state:

- **What** the skill makes the agent do
- **When** it should load (triggers)
- **Change**: what must start working, stop happening, or be added. Quote the user. If they only asked for a tightness pass, the change is "checklist only"

If any of those is unclear, **stop and ask**, as the Constraints say, and edit only after the answers. Ask only for decisions: purpose, key functionality, what "working" means for the complaint, trigger phrases.

### 4. Diagnose the requested change

Skip this step on a checklist-only pass.

Find why the current skill fails at X. Typical causes:

- Instruction missing, buried in a sibling file, or contradicted
- Too much freedom on a fragile step (needs an exact command or script)
- Description differs from how the user asks, so the skill never loads
- `ace-mode` has no route to the skill, and no other skill links it by path, so it never loads
- The failing rule is easy to misread and has no example. Other rules need none just because this one does
- Agent is told to audit or report, but not to change behaviour
- The rule names the unwanted action ("do not X") instead of the wanted one

Write the smallest instruction or script that makes X the default path, phrased as the action to take. Add an example only if that instruction is still easy to misread, and only for that rule. Put the fix on the main path, as a step the agent must take, not a parallel optional branch.

If you cannot tell what "X works" looks like, ask. A vague "be more careful about X" is not a fix.

### 5. Audit

Run `scripts/check-wording.sh <skill-folder>`. Then score against [CHECKLIST.md](CHECKLIST.md). Keep findings as concrete line-level issues, not vibes.

### 6. Edit

Surgical. Match the skill's existing tone if it is already plain.

Priority, in order:

1. Requested behaviour (make X work)
2. Frontmatter `name` and `description`, per Discovery in [CHECKLIST.md](CHECKLIST.md)
3. Apply Authoring, including the goal, the constraints section, and the wording rule
4. One default path; one escape hatch
5. Split oversized bodies into sibling files linked from `SKILL.md`
6. Match freedom to fragility (heuristics vs templates vs exact scripts)
7. Make scripts the source of truth for brittle, repeatable steps

On every pass, including checklist-only, fix each line `scripts/check-wording.sh` lists, as the wording rule in Authoring and the em dash line in [CHECKLIST.md](CHECKLIST.md) say.

### 7. Re-audit

Re-read what you wrote and re-run step 5. Every line the wording check still lists is a fact or a condition. Confirm the requested change is an instruction the agent must follow, not a note.

### 8. Report

```
Purpose: <one sentence>
Triggers: <phrases>
Requested: <X, or "checklist only">
How X is solved: <the new or changed instruction, or "n/a">
Changed: <bullet list of edits and why>
Left alone: <what you kept as it was, and why>
Still unclear: <questions, or "none">
```
