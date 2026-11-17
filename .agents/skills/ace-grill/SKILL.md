---
name: ace-grill
description: Interviews until the plan is settled, updates the glossary as terms resolve, and writes the settled plan into a ticket.
disable-model-invocation: true
---

# Ace grill

Interview the user until you reach a shared understanding. Record resolved terms while you go. Done means the frontier is empty, the settled plan is summarized, and it is in a ticket, unless the user chose no ticket or the project has no ticket tracker.

## Requires

- `ace-unslop`
- `ace-to-ticket`

## Constraints

- Write to the glossary: its section in the root agents file, and `ace/GLOSSARY.md` when it exists. Write to tickets only through `ace-to-ticket`.
- Never set a ticket to `ready`. A new ticket gets the tracker's default state. An existing ticket keeps its state.
- Implementing belongs to the caller.

## Ticket

When `ace/TICKET_TRACKER.md` is missing, skip every ticket step and end with the summary in the chat.

When the conversation names a ticket, read it with its comments as `ace/TICKET_TRACKER.md` says, before the first round. Do not ask for it.

Otherwise ask in the first round whether a ticket exists for this plan. If the user gives one, read it with its comments before the next round. Use what the ticket answers, and ask only what it leaves open.

## Interview

Map the plan as a design tree. Every decision branches into the decisions that hang off it.

Work the tree in rounds. The frontier is every decision whose prerequisites are already settled: the questions you can ask now without guessing at answers you have not heard yet. Ask the whole frontier in one round. Number each question and give your recommended answer. Then wait for the user's answers before the next round.

Write the questions in the question format of `ace-unslop`.

Each round the user answers reshapes the tree. Settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a later round.

Finding facts is your job. When a frontier question needs a fact from the environment (filesystem, tools, and so on), dispatch a sub-agent to find it, and ask the user only for decisions. Keep the round moving while it runs: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report. Ask the rest of the frontier now. The decisions are the user's. Put each to them and wait.

When no ticket is known, the last round also asks: open a new ticket, or no ticket? Recommend a new ticket when the work is size `L` or `XL`, needs more than one context window, or should wait. Otherwise recommend no ticket.

The interview is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed.

## Close

1. Summarize the settled plan: each decision and its answer, and the terms you added to the glossary.
2. When a ticket is known, or the user chose a new one, run [ace-to-ticket](../ace-to-ticket/SKILL.md) with the settled plan as the spec. A known ticket is the spec ticket, and `ace-to-ticket` rewrites its body. When the caller says to keep one ticket, tell `ace-to-ticket` to use single-ticket mode.
3. Stop. Hand back the ticket URLs, or say that the plan stays in the chat.

## Docs

When a term is resolved, add it to the Glossary section of the root agents file right away, one term at a time, as `- **term**: what it means here. Not: other words for it.` Leave out `Not:` when no other word is in use. When `ace/GLOSSARY.md` exists, put what does not fit on one line there. Record decisions in the conversation, not in the glossary.

When the section passes about 40 terms, or one word turns out to mean different things in different parts of the project, propose creating `ace/GLOSSARY.md` for the detail. The section keeps the one-line entries and points at the file.
