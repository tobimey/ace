---
name: ace-skill-optimizer
description: Edits an existing Agent Skill so it does what the user needs in as little context as possible.
disable-model-invocation: true
---

# Skill optimizer

Edit an existing skill so it does what the user needs, an agent can find it, and it spends as little context as possible.

What done looks like: the requested behaviour is an instruction the agent must follow, the skill passes [CHECKLIST.md](CHECKLIST.md), and the report is filled in.

User-requested behaviour wins over a pure checklist pass. If they say X is failing or missing, the job is to make X work, then still pass [CHECKLIST.md](CHECKLIST.md).

## Authoring

This skill is the only prefix list.

- `ace-audit` is the auditor job. Repo-wide, one domain file per domain, one pass per domain. It files tickets. It leaves the repo unchanged and opens no pull request.
- `ace-review` is the review job for the current change. One check file per check: spec, standards, and code.
- `ace-` plus a verb is a cycle or shared job. A person is in the loop, or another skill calls it.
- Skills without the `ace-` prefix are project or vendored skills. They teach a library or a tool. Keep ace pipeline facts out of them.

- An ace skill is generic. It names no project, stack, framework, database, command, path, or trust boundary of one project. Those facts live in the project's `ace/` files, and the skill points there.
- Write the body so it works in any context that loads it: any caller (slash command, UI, parent skill, route) and any machine. When `disable-model-invocation` is omitted, discovery `when` belongs in `description`.
- A job skill takes its input from the caller: a pull request, a diff, a base ref, or a ticket.
- Name another skill by its `name`. Name a document by its role (coding standards, glossary) or its `ace/` path. Name another filesystem path only when that path is the work.
- When the skill follows, loads, or runs another skill, list that skill in a `## Requires` section before the first other section, as a list of names and nothing else. The Ace section of the root agents file says what happens when one is missing. A skill named only to mark scope, such as "belongs to `ace-review`", needs no entry.
- Leave out how to find an adapter section and what to do when one is missing. `ace-adapters` says it, with each section's default. Write a line only when the skill does something else, such as answering in the reply instead of posting.
- When `disable-model-invocation` is `true`, the description is one line that says what the skill does, and only what.
- Write every instruction as the action to take. Turn "do not X", "never X", "avoid X", and "should not X" into what the agent does instead: the allowed scope ("Read only.", "Change only the files in the diff."), the replacement action, or the stop condition ("If the section is missing, stop and say so."). A negation that states a fact or a condition ("if the file does not exist") stays. Naming the unwanted action plants it; naming the wanted one steers.
- Shortest text that still makes the agent do the job. Say each rule once.
- Most rules need no example. Add one only when a capable model keeps applying the rule wrong without it. A skill with many rules should have few examples, not one per rule.
- Cut what a capable model already knows.
- State the goal and what done looks like, near the start. If the opening already says that, leave it.
- Include one section for constraints: the scope and boundaries of the job, each written as the action to take. An existing section that already does that job counts. Keep it and fix its wording.

## Constraints

- Edit the named skill only. A new skill is a job for `ace-create-skill`.
- Keep the skill's purpose and features as they are, plus what the user asked for.
- Keep the skill's voice. Rewrite it only where it is bloated or inconsistent.
- Keep the skill folder to agent files: `SKILL.md`, the files it links, `scripts/`, and `agents/openai.yaml`.

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

If any of those is unclear, **stop and ask**, and edit only after the answers.

Ask with the harness's question tool when it has one. Otherwise ask in chat, in the question format of `ace-mode`.

Look up filesystem facts yourself. Ask only for decisions: purpose, key functionality, what "working" means for the complaint, trigger phrases.

Wait for answers before editing.

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
2. Frontmatter `name` and `description`, using the Authoring rule for `disable-model-invocation`
3. Apply Authoring, including the goal, the constraints section, and the wording rule
4. One default path; one escape hatch
5. Split oversized bodies into sibling files linked from `SKILL.md`
6. Match freedom to fragility (heuristics vs templates vs exact scripts)
7. Make scripts the source of truth for brittle, repeatable steps

On every pass, including checklist-only, fix each line `scripts/check-wording.sh` lists. Replace an em dash with a period or a comma; an en dash or a hyphen used as a dash is not a fix. Rewrite a negation as the action to take, unless it states a fact or a condition.

### 7. Re-audit

Re-read what you wrote. Run `scripts/check-wording.sh <skill-folder>` again; every line it still lists is a fact or a condition. Confirm the requested change is an instruction the agent must follow, not a note. Authoring holds. The skill states the goal and what done looks like, and it has one constraints section. `SKILL.md` body under 500 lines. Description under 1024 characters, third person, what and when only. When `disable-model-invocation` is `true`, the description is one line that says what the skill does. When that field is omitted, the description answers what and when. Links one level deep.

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
