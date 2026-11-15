---
name: ace-grill
description: Interviews until the plan is settled, and updates the glossary as terms resolve.
disable-model-invocation: true
---

# Ace grill

Interview the user until you reach a shared understanding. Record resolved terms and decisions while you go. Start implementing only after the user confirms you have reached that understanding.

## Interview

Map the plan as a design tree. Every decision branches into the decisions that hang off it.

Work the tree in rounds. The frontier is every decision whose prerequisites are already settled: the questions you can ask now without guessing at answers you have not heard yet. Ask the whole frontier in one round. Number each question and give your recommended answer. Then wait for the user's answers before the next round.

Write the questions in the question format of `ace-unslop`.

Each round the user answers reshapes the tree. Settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a later round.

Finding facts is your job. When a frontier question needs a fact from the environment (filesystem, tools, and so on), dispatch a sub-agent to find it, and ask the user only for decisions. Keep the round moving while it runs: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report. Ask the rest of the frontier now. The decisions are the user's. Put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed.

## Docs

When a term is resolved, update `ace/GLOSSARY.md` right away, one term at a time. Record decisions in the glossary and the conversation only, with no ADRs.
