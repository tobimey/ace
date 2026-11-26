---
name: ace-grill
description: Settles what to build before any code changes. It judges a proposed change, helps pick a direction when none is set, interviews until the plan is settled, and writes the plan into a ticket.
disable-model-invocation: true
---

# Ace grill

Settle what to build: **which** direction, **whether** a proposed change is worth it, and **how** to build it. Done means the How frontier is empty, the settled plan is summarized, and it is in a ticket, a temporary plan in `ace/temporary-plans/`, or chat for `S` work. A run also ends when the user picks no direction or stops after a verdict.

## Requires

- `ace-to-ticket`

## Constraints

- Start at the first open level. No direction picked ("how can I make X better"): follow [DIRECTION.md](DIRECTION.md). A proposed change: Whether. A settled premise, such as a ready ticket or a caller that names the open decisions: How.
- Wait for the user at the end of each level.
- Write glossary terms only at Close, as "Docs" says. Write ADRs to `ace/adrs/`. Write to tickets only through `ace-to-ticket`, which also sets their state.
- Implementing belongs to the caller.

## Whether

Judge the proposed change. Find the facts yourself: is the problem real and how big (measure it when you can), does the change solve it and at what cost, and what is the cheapest alternative. The verdict is do it, do it differently (name how), or leave it. Give "do it" whenever the facts support it.

When the message asks for an opinion ("what do you think"), or the verdict is not "do it", write the facts in a few lines and the verdict, then ask: plan it as proposed, plan the alternative, or stop? Wait for the answer. Otherwise say "do it" in one line and go on with How.

## Ticket

With no ticket tracker per [ADAPTERS.md](../ace-mode/shared/adapters/ADAPTERS.md), skip all ticket steps. Work bigger than `S` that ends with no ticket gets its plan in `ace/temporary-plans/<slug>.md` at Close (keep `S` plans in chat).

When the conversation names a ticket, read it and its comments per `ace/TICKET_TRACKER.md` before the first round, and ask only what it leaves open. Otherwise skip asking for a ticket in round 1, and ask whether to link or open one in the final round only when the work is `L`/`XL`, needs multiple context windows, or should wait.

## How

Map material decisions as a design tree: only decisions that materially change behavior, UX, data shape, or public contracts. For low-stakes, easily reversible details, pick sensible defaults and list them in one line instead of asking.

Work the tree in rounds. The frontier is every material decision whose prerequisites are settled. Ask the whole frontier in one round using [QUESTIONS.md](../ace-mode/QUESTIONS.md), then wait. Settled answers push the frontier outward for the next round; questions depending on an open answer wait for a later round.

Finding facts is your job. When a frontier question needs a fact from the codebase or tools, dispatch a sub-agent and ask the user only for decisions, keeping independent frontier questions moving while it runs.

In the last round, include these only when relevant:
- **Glossary**: only if you noted new terms, list them and ask whether to add them (and which are core when `ace/GLOSSARY.md` exists).
- **Ticket**: only if a tracker is configured, no ticket is known, and the work is `L`/`XL`, multi-window, or waiting, ask whether to link or open a ticket.

How is done when no material decision remains open (including zero rounds when defaults cover everything). On a fast-track request ("just build it", "go with your recommendations"), take your recommended answers for any open decisions, list them in one line, and go straight to Close.

## Close

1. Summarize the settled plan: each decision and its answer, and the glossary terms you noted.
2. Add each term the user said yes to into the glossary, as "Docs" says.
3. When `write_adrs` in `ace/config.json` is `true` (default `false`), write an ADR for each settled decision that meets the bar in [ADR.md](ADR.md). Name each new ADR in the summary.
4. When a ticket is known, or the user chose a new one, run [ace-to-ticket](../ace-to-ticket/SKILL.md) with the settled plan as the spec (rewrite a known ticket; pass single-ticket mode when asked). Otherwise, when the work is bigger than `S`, write the settled plan to `ace/temporary-plans/<slug>.md` and add `ace/temporary-plans/` to `.gitignore` if missing.
5. Stop. Hand back the ticket URLs, the temporary plan path (suggesting a fresh session with `Implement ace/temporary-plans/<slug>.md`), or say that the plan stays in chat.

## Docs

When a term is resolved, note it for Close. At Close, add each noted term the user said yes to as [the glossary contract](../ace-mode/shared/adapters/contract/GLOSSARY.md) says, and propose creating `ace/GLOSSARY.md` when the contract says it is due. A run that stops before Close writes no term. Record decisions in the conversation and in ADRs, not in the glossary.
