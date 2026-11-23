---
name: ace-skill-best-practices
description: Creates a new Agent Skill or edits an existing one, so it does what the user needs in as little context as possible.
disable-model-invocation: true
---

# Skill best practices

Create or edit a skill so it does what the user needs, an agent can find it, and it spends as little context as possible. Done means the skill passes [CHECKLIST.md](CHECKLIST.md), the requested behaviour is an instruction the agent must follow, and the workflow's report is filled in.

Pick the workflow:

- A new skill: [CREATE.md](CREATE.md).
- A change to an existing skill, or a checklist-only pass: [EDIT.md](EDIT.md).

A skill that writes other steering files, such as `ace-optimize-factory`, follows the Authoring section and runs [check-wording.sh](scripts/check-wording.sh) on each file, without a workflow.

## Authoring

This skill is the only prefix list.

- `ace-audit` is the auditor job. Repo-wide, one domain file per domain, one pass per domain. It files tickets. It leaves the repo unchanged and opens no pull request.
- `ace-garden` is the gardener job. One topic file per topic, one scope and one fix per run. It changes code and files no ticket.
- `ace-review` is the review job for the current change. One check file per check: spec, standards, and code.
- `ace-` plus a verb is a cycle or shared job. A person is in the loop, or another skill calls it.
- Skills without the `ace-` prefix are project or vendored skills. They teach a library or a tool. Keep ace pipeline facts out of them.

- An ace skill is generic. It names no project, stack, framework, database, command, path, or trust boundary of one project. Those facts live in the project's `ace/` files, and the skill points there.
- Write the body so it works in any context that loads it: any caller (slash command, UI, parent skill, route) and any machine. When `disable-model-invocation` is omitted, discovery `when` belongs in `description`.
- A job skill takes its input from the caller: a pull request, a diff, a base ref, or a ticket.
- Name another skill by its `name`. Name a document by its role (coding standards, glossary) or its `ace/` path. Name another filesystem path only when that path is the work.
- When the skill follows, loads, or runs another skill, list that skill in a `## Requires` section before the first other section, as a list of names and nothing else. The Ace section of the root agents file says what happens when one is missing. A skill named only to mark scope, such as "belongs to `ace-review`", needs no entry.
- Leave out how to find an adapter section and what to do when one is missing. [ADAPTERS.md](../ace-mode/shared/adapters/ADAPTERS.md) says it, with each section's default. Write a line only when the skill does something else, such as answering in the reply instead of posting.
- When `disable-model-invocation` is `true`, the description is one line that says what the skill does, and only what.
- Write every instruction as the action to take. Turn "do not X", "never X", "avoid X", and "should not X" into what the agent does instead: the allowed scope ("Read only.", "Change only the files in the diff."), the replacement action, or the stop condition ("If the section is missing, stop and say so."). A negation that states a fact or a condition ("if the file does not exist") stays. Naming the unwanted action plants it; naming the wanted one steers.
- Shortest text that still makes the agent do the job. Say each rule once.
- Most rules need no example. Add one only when a capable model keeps applying the rule wrong without it. A skill with many rules should have few examples, not one per rule.
- Cut what a capable model already knows.
- State the goal and what done looks like, near the start. If the opening already says that, leave it.
- Include one section for constraints: the scope and boundaries of the job, each written as the action to take. An existing section that already does that job counts. Keep it and fix its wording.

## Constraints

- Create or edit one skill: the one the user named or asked for.
- User-requested behaviour wins over a pure checklist pass. If they say X is failing or missing, the job is to make X work, then still pass [CHECKLIST.md](CHECKLIST.md).
- Keep the skill folder to agent files: `SKILL.md`, the files it links, `scripts/`, and `agents/openai.yaml`.
- Look up facts yourself. Ask the user only for decisions. Ask with the harness's question tool when it has one. Otherwise ask in chat, in the question format in [QUESTIONS.md](../ace-mode/QUESTIONS.md). Wait for the answers.
