---
name: ace-grill
description: Settles what to build before any code changes. It judges a proposed change, helps pick a direction when none is set, interviews until the plan is settled, and writes the plan into a ticket.
disable-model-invocation: true
---

# Ace grill

Settle what to build: **which** direction, **whether** a proposed change is worth it, and **how** to build it. Done means the How frontier is empty, the settled plan is summarized, and it is in a ticket, unless the user chose no ticket or the project has no ticket tracker. A run also ends when the user picks no direction or stops after a verdict.

## Requires

- `ace-to-ticket`

## Constraints

- Start at the first open level. No direction picked ("how can I make X better"): follow [DIRECTION.md](DIRECTION.md). A proposed change: Whether. A settled premise, such as a ready ticket or a caller that names the open decisions: How.
- Wait for the user at the end of each level.
- Write to the glossary only at Close, and only the terms the user said yes to: its section in the root agents file, and `ace/GLOSSARY.md` when it exists. A run that stops before Close writes no glossary term. Write ADRs to `ace/adrs/`. Write to tickets only through `ace-to-ticket`, which also sets their state.
- Implementing belongs to the caller.

## Whether

Judge the proposed change. Find the facts yourself: is the problem real and how big (measure it when you can), does the change solve it and at what cost, and what is the cheapest alternative. The verdict is do it, do it differently (name how), or leave it. Give "do it" whenever the facts support it.

When the message asks for an opinion ("what do you think"), or the verdict is not "do it", write the facts in a few lines and the verdict, then ask: plan it as proposed, plan the alternative, or stop? Wait for the answer. Otherwise say "do it" in one line and go on with How.

## Ticket

When the project has no ticket tracker, as `ace-adapters` says, skip every ticket step and end with the summary in the chat.

When the conversation names a ticket, read it with its comments as `ace/TICKET_TRACKER.md` says, before the first round. Do not ask for it.

Otherwise ask in the first round whether a ticket exists for this plan. If the user gives one, read it with its comments before the next round. Use what the ticket answers, and ask only what it leaves open.

## How

Map the plan as a design tree. Every decision branches into the decisions that hang off it.

Work the tree in rounds. The frontier is every decision whose prerequisites are already settled: the questions you can ask now without guessing at answers you have not heard yet. Ask the whole frontier in one round. Number each question and give your recommended answer. Then wait for the user's answers before the next round.

Write the questions in the question format in [QUESTIONS.md](../ace-mode/QUESTIONS.md).

Each round the user answers reshapes the tree. Settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a later round.

Finding facts is your job. When a frontier question needs a fact from the environment (filesystem, tools, and so on), dispatch a sub-agent to find it, and ask the user only for decisions. Keep the round moving while it runs: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report. Ask the rest of the frontier now. The decisions are the user's. Put each to them and wait.

The last round also lists the glossary terms you noted and asks whether to add them. When no ticket is known, it also asks: open a new ticket, or no ticket? Recommend a new ticket when the work is size `L` or `XL`, needs more than one context window, or should wait. Otherwise recommend no ticket.

How is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed.

## Close

1. Summarize the settled plan: each decision and its answer, and the glossary terms you noted.
2. Add each term the user said yes to into the glossary, as "Docs" says.
3. When `write_adrs` in `ace/config.json` is `true` (default `false`), write an ADR for each settled decision that meets the bar in [ADR.md](ADR.md). Name each new ADR in the summary.
4. When a ticket is known, or the user chose a new one, run [ace-to-ticket](../ace-to-ticket/SKILL.md) with the settled plan as the spec. A known ticket is the spec ticket, and `ace-to-ticket` rewrites its body. When the caller says to keep one ticket, tell `ace-to-ticket` to use single-ticket mode.
5. Stop. Hand back the ticket URLs, or say that the plan stays in the chat.

## Docs

When a term is resolved, note it for Close. At Close, add each noted term the user said yes to into the Glossary section of the root agents file as `- **term**: what it means here. Not: other words for it.` Leave out `Not:` when no other word is in use. When `ace/GLOSSARY.md` exists, put what does not fit on one line there. Record decisions in the conversation and in ADRs, not in the glossary.

When the section passes about 40 terms, or one word turns out to mean different things in different parts of the project, propose creating `ace/GLOSSARY.md` for the detail. The section keeps the one-line entries and points at the file.
