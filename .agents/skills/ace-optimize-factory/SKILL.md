---
name: ace-optimize-factory
description: Fixes how future agents are steered, given a problem or misbehaviour, runs a retro on one or more sessions to find what to fix, or checks the repo's AGENTS.md and CLAUDE.md and proposes edits.
disable-model-invocation: true
---

# Optimize factory

You were given a problem or misbehaviour in how agents are steered. Find the smallest change that stops the next agent from repeating it.

When the user asks for a retro, or to look back on a whole session or several, there is no named problem yet. Follow [RETRO.md](RETRO.md) first. It finds the candidates and hands each one the user picks back to the workflow below.

When the user asks to check or improve the agents file (`AGENTS.md`, `CLAUDE.md`) with no named problem, follow [AGENTS_FILE.md](AGENTS_FILE.md) instead of the workflow below.

What done looks like: a concrete edit in a skill, `ace/config.json`, `AGENTS.md`, a lint or CI check, coding standards, the glossary, or another file future agents read. Or the user chose a new architecture and you applied it.

## Requires

- `ace-skill-best-practices`

## Constraints

- Change files that steer agents. Touch product code only when that is the only way to steer the next agent.
- Build only the fix the problem needs. Record the decision in the edited file itself.
- When a setting in `ace/config.json` covers the misbehaviour, such as who sets a ticket ready, change that setting and edit no skill.
- Prefer a check over a prose rule. Prefer a small edit over a new skill. Prefer a new skill over a new architecture.
- Write each fix as the behaviour you want next time. "The agent edits generated files" becomes "Change skills in the source folder; reinstall to update the copies." Use the wording rule in [ace-skill-best-practices](../ace-skill-best-practices/SKILL.md) for every steering file you write, and run its [check-wording.sh](../ace-skill-best-practices/scripts/check-wording.sh) on each one.
- When you edit a skill, follow the Edit workflow of [ace-skill-best-practices](../ace-skill-best-practices/SKILL.md) and pass the checklist it links.
- When you edit `AGENTS.md` or `CLAUDE.md`, follow the Rules in [AGENTS_FILE.md](AGENTS_FILE.md).
- Look up facts yourself. Ask the user only for decisions.

## Workflow

1. Restate the problem in one sentence. If it is unclear, ask once and wait.
2. Find where the next agent is steered into this mistake. Read the files that already cover that job.
3. List real options. Start with the smallest change that would work. Add a new architecture only when the current shape cannot hold the fix.
4. If one fix is obvious, apply it and say what changed.
5. If several options are real, or the change is bigger and some decisions are not obvious, ask with the format below. Multiple questions are fine. Skip any whose answer is already clear. Wait, then apply what the user chose.

## Ask

Number each question. Give your recommended answer. Then wait. If a later question depends on this round, ask it next round.

Write the questions in the question format in [QUESTIONS.md](../ace-mode/QUESTIONS.md).
