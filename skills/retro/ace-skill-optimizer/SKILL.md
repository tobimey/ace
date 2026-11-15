---
name: ace-skill-optimizer
description: Edit an existing Agent Skill.
disable-model-invocation: true
---

# Skill optimizer

Edit an existing skill so it does what the user needs, an agent can find it, and it does not waste context.

What done looks like: the requested behaviour is an instruction the agent must follow, the skill passes [CHECKLIST.md](CHECKLIST.md), and the report is filled in.

User-requested behaviour wins over a pure checklist pass. If they say X is failing or missing, the job is to make X work, then still pass [CHECKLIST.md](CHECKLIST.md).

## Authoring

This skill is the only prefix list.

- `ace-audit-` is an auditor job. Repo-wide. It files tickets. It does not edit the repo or open a pull request. It is not a Cursor Cloud Agent run, so it has no `ace-run-*` skill.
- `ace-gardening-` is a gardening job. One scope, asked for by a person or by another skill.
- `ace-review` is a review job for the current change. The skills are `ace-review`, `ace-check-spec`, and `ace-validate-standards`.
- `ace-run-` is a Cursor Cloud Agent starter. It follows `ace-env-cursor-cloud-agent` and names the job. A local chat does not load it.
- `ace-env-` states the facts of one runner: who answers, tokens, secrets, branch rules. It does not name a job. A starter loads it. The only one is `ace-env-cursor-cloud-agent`.
- `ace-` plus a verb is a dev or shared job. A person is in the loop, or another skill calls it.
- `verify-hedwig` is inactive. It has no `ace-` prefix, on purpose. Do not load it and do not run it.
- Vendored skills have no `ace-` prefix. They teach a library or a tool. They are pinned in `skills-lock.json`. Leave pipeline, labels, and runner facts out of them. Change them by updating the lock.

- Do not bake in where a job skill is invoked (slash command, UI, parent skill, route). The body must work in any context that loads it. When `disable-model-invocation` is omitted, discovery `when` belongs in `description`.
- A job skill does not name the runner. The caller passes a pull request, a diff, a base ref, or a ticket.
- An `ace-run-*` skill names Cursor Cloud Agent, says a local chat does not load it, follows `ace-env-cursor-cloud-agent`, and names the job. Do not delete those lines. Do not restate the job or the cloud facts. After the job skill returns, the starter posts, pushes, and moves labels for that run.
- When an `ace-run-*` skill posts a pull request comment, review, or inline comment, it follows `ace/CODE_HOSTING.md`. Do not copy those identity rules into the starter. Do not use `gh` or the PAT for comments.
- Name another skill by its `name`. Do not write a path under `.agents/skills/`. Name a document by its role (coding standards, accepted risks, glossary). `AGENTS.md` is the path index. Name a filesystem path only when that path is the work. Do not point a skill at `docs/software-factory`. That folder documents the setup. It may point at skills.
- When `disable-model-invocation` is `true`, the description is one line and does not say when to invoke the skill.
- Shortest text that still makes the agent do the job. Say each rule once.
- Most rules need no example. Add one only when a capable model keeps applying the rule wrong without it. A skill with many rules should have few examples, not one per rule.
- Cut what a capable model already knows.
- State the goal and what done looks like, near the start. If the opening already says that, leave it.
- Include one section for constraints and forbidden actions. An existing section that already does that job counts. Leave it.

## Constraints

- Do not create a new skill.
- Do not invent purpose or extra features.
- Do not rewrite voice unless the current text is bloated or inconsistent.
- Do not add README, CHANGELOG, or other human docs inside the skill folder.

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

Use the skill the user named, attached, or has open. Search `.agents/skills/` and the user Agent Store if needed. Folder name must match frontmatter `name`. If several match, ask which one.

### 2. Read

Read `SKILL.md` fully. Read every file it links (one level). List `scripts/` and note whether the body says **run** or **read**.

### 3. Gate: purpose, triggers, requested change

Before any edit, state:

- **What** the skill makes the agent do
- **When** it should load (triggers)
- **Change**: what must start working, stop happening, or be added. Quote the user. If they only asked for a tightness pass, the change is "checklist only"

If any of those is unclear, **stop and ask**. Do not guess and then rewrite.

Ask with the AskQuestion tool when available. Otherwise ask in chat. Number the questions. Offer a recommended answer when you have one.

Look up filesystem facts yourself. Ask only for decisions: purpose, key functionality, what "working" means for the complaint, trigger phrases, slash-only vs auto-load (`disable-model-invocation: true`).

Wait for answers before editing.

### 4. Diagnose the requested change

Skip this step on a checklist-only pass.

Find why the current skill fails at X. Typical causes:

- Instruction missing, buried in a sibling file, or contradicted
- Too much freedom on a fragile step (needs an exact command or script)
- Description does not match how the user asks, so the skill never loads
- `disable-model-invocation: true` when they expect auto-load, or the reverse
- The failing rule is easy to misread and has no example. Other rules do not need one just because this one does
- Agent is told to audit or report, but not to change behaviour

Write the smallest instruction or script that makes X the default path. Add an example only if that instruction is still easy to misread. Do not add examples for other rules on the same pass. Do not add a parallel optional branch that the agent can ignore.

If you cannot tell what "X works" looks like, ask. Do not ship a vague "be more careful about X".

### 5. Audit

Score against [CHECKLIST.md](CHECKLIST.md). Keep findings as concrete line-level issues, not vibes.

### 6. Edit

Surgical. Match the skill's existing tone if it is already plain.

Priority, in order:

1. Requested behaviour (make X work)
2. Frontmatter `name` and `description`, using the Authoring rule for `disable-model-invocation`
3. Apply Authoring, including the goal and the constraints section
4. One default path; one escape hatch
5. Split oversized bodies into sibling files linked from `SKILL.md`
6. Match freedom to fragility (heuristics vs templates vs exact scripts)
7. Make scripts the source of truth for brittle, repeatable steps

On every pass, including checklist-only, replace each em dash (`—`) in the skill folder. Use a period or a comma. Do not substitute an en dash or a hyphen used as a dash.

### 7. Re-audit

Re-read what you wrote. Confirm the requested change is an instruction the agent must follow, not a note. Authoring holds. The skill states the goal and what done looks like, and it has one section for constraints and forbidden actions. `SKILL.md` body under 500 lines. Description under 1024 characters, third person, no step-by-step how. When `disable-model-invocation` is `true`, the description is one line and does not say when to invoke the skill. When that field is omitted, the description answers what and when. Links one level deep. The skill folder contains no em dash (`—`).

### 8. Report

```
Purpose: <one sentence>
Triggers: <phrases>
Requested: <X, or "checklist only">
How X is solved: <the new or changed instruction, or "n/a">
Changed: <bullet list of edits and why>
Left alone: <what you did not touch, and why>
Still unclear: <questions, or "none">
```
