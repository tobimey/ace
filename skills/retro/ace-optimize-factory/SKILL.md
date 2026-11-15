---
name: ace-optimize-factory
description: Fixes how future agents are steered, given a problem or misbehaviour.
disable-model-invocation: true
---

# Optimize factory

You were given a problem or misbehaviour in how agents are steered. Find the smallest change that stops the next agent from repeating it.

What done looks like: a concrete edit in a skill, `AGENTS.md`, a lint or CI check, coding standards, the glossary, or another file future agents read. Or the user chose a new architecture and you applied it.

## Constraints

- Do not change product code unless that is the only way to steer the next agent.
- Do not invent extra factory features.
- Do not write ADRs.
- Prefer a check over a prose rule. Prefer a small edit over a new skill. Prefer a new skill over a new architecture.
- When you edit a skill, read `ace-skill-optimizer` and pass the checklist it links.
- Look up facts yourself. Ask the user only for decisions.

## Workflow

1. Restate the problem in one sentence. If it is unclear, ask once and wait.
2. Find where the next agent is steered into this mistake. Read the files that already cover that job.
3. List real options. Start with the smallest change that would work. Add a new architecture only when the current shape cannot hold the fix.
4. If one fix is obvious, apply it and say what changed.
5. If several options are real, or the change is bigger and some decisions are not obvious, ask with the format below. Multiple questions are fine. Skip any whose answer is already clear. Wait, then apply what the user chose.

## Ask

Number each question. Give your recommended answer. Then wait. If a later question depends on this round, ask it next round.

Write the questions as plain text in the chat. Do not put them inside a markdown fence. Do not use bold, headings, or other markdown on the question lines.

Each question is two plain lines:

❓ Q1 - <question title>: <question body>

➡️ <your recommended answer>

When you write the questions, read and follow `ace-unslop`. Keep the ❓ and ➡️ markers. Unslop rule 18 does not apply to them.

The question is a few sentences. If there are choices, put each on its own line as plain text, not a markdown list. The recommended answer is one sentence. Use plain words. If you need a specialist term, define it in the same sentence.
