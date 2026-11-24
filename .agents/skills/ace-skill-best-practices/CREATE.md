# Create a skill

Done means the skill folder exists, it passes [CHECKLIST.md](CHECKLIST.md), and the report is filled in. Follow the Authoring section and the Constraints of [SKILL.md](SKILL.md) throughout.

Create the skill in the folder the user names. Otherwise use the folder that holds the project's other skills, and ask when there are several.

## Workflow

```
- [ ] 1. Gate: job, triggers, done
- [ ] 2. Check for overlap
- [ ] 3. Design
- [ ] 4. Write
- [ ] 5. Audit
- [ ] 6. Report
```

### 1. Gate

Before writing anything, state:

- **Job**: what the skill makes the agent do, as one verb
- **Triggers**: when it loads, and whether it runs only when named or loads on its own
- **Input**: what the caller passes, such as a pull request, a diff, a ticket, or a question
- **Done**: what is true after a run

If any of these is unclear, stop and ask, as the Constraints say, and wait for the answers.

### 2. Check for overlap

Read the name and description of every installed skill. When one already does the job or most of it, stop and propose changing that skill with [EDIT.md](EDIT.md).

When the new skill needs a step another skill already does, call that skill. Write the step once, in one skill.

### 3. Design

- **Name**: follow the prefix rules in Authoring. The folder name matches `name`.
- **Invocation**: as Frontmatter in [CHECKLIST.md](CHECKLIST.md) says.
- **Freedom**: match it to how fragile the step is. Judgement work gets the goal and the rules. A fragile sequence gets exact commands. A deterministic step, such as validate, parse, count, or call an API, gets a script in `scripts/` that prints its result.
- **Project facts**: point to the `ace/` file and the section that holds them, and find the section by its job. When an Ace skill needs a section no adapter has, add it to that adapter's file in `ace-mode/shared/adapters/contract/`, with its default, and to the matching template in `ace-setup`.
- **Other skills**: list each skill the new one follows, loads, or runs in its Requires section, as Authoring says.

### 4. Write

Start from this skeleton and fill it per the Authoring rules:

```markdown
---
name: <name>
description: <one line: what it does>
disable-model-invocation: true
---

# <Title>

<The goal. Done means ...>

## Constraints

- <Scope and boundaries, each as the action to take.>

## Workflow

1. <Step, as the action to take.>

## Report

<The shape of what the skill hands back, when it hands something back.>
```

Drop the Report section when the skill hands nothing back. Move a long reference into a sibling file and link it from `SKILL.md`, one level deep.

For an Ace skill, add it to the matching playbook in `ace-mode`, so the router can reach it.

### 5. Audit

1. Run `scripts/check-wording.sh <skill-folder>`. Fix each line it lists. A line may stay only when it states a fact or a condition.
2. Score the skill against [CHECKLIST.md](CHECKLIST.md) and fix each miss.
3. Dry run. Take one realistic input from step 1, read the skill as a fresh agent that has only this file, and walk every step. Fix each step where that agent would have to guess.
4. Repeat until the wording check and the checklist pass and the dry run needs no guess.

### 6. Report

```
Purpose: <one sentence>
Triggers: <phrases, or "by name only">
Files: <each file created>
Design choices: <name, invocation, freedom, and why>
Still unclear: <questions, or "none">
```
