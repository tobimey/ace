---
name: ace-setup
description: Guides the user step by step through setting up Ace in a project (core setup, full setup, or named modules such as tickets or standards), or updates an existing setup after an Ace update.
disable-model-invocation: true
---

# Ace Setup

Guide the user step by step through setting up Ace in this project. Core setup turns on interactive chat and verification; optional modules customize chat & reviews (`standards`, `settings`) or add tickets & automation (`tickets`, `cycle`).

Done means every step of the chosen run finished, every written file has no `<PLACEHOLDER>` left, and the user received the final summary.

## Step-by-step experience

Follow these rules on every turn of setup:

1. **One step at a time**: silently inspect the project first, print the step card, wait for the user's reply, then apply the confirmed change and advance.
2. **Use the step card**: print each step as this card. A guide's step heading gives the counter, emoji, and title, and its bullets give **Why**, a summary label with `·`-separated items, **Question** with its options, and **Recommend**. Keep that wording, and fill `<slots>` from the project. Ask its decision in the format of [QUESTIONS.md](../ace-mode/QUESTIONS.md), one decision per turn. Omit `of <Y>` while the total depends on an answer.

   ```markdown
   ### <emoji> Step <X> of <Y> · <Title>

   **Why:** <one or two short sentences>

   **<summary label>:**
   - <one compact bullet per item>

   **❓ 1 - <Question>**

   - **A)** <option>
   - **B)** <option>

   ➡️ <recommendation>
   ```
3. **No internal jargon**: keep internal Ace terms (such as "adapter", "contract", or "provider") and internal skill paths out of chat replies. Name only the project files being created or updated.
4. **Fast-track on request**: when the user asks to run automatically or skip confirmations, write the remaining drafts directly and show one compact final recap.

## Pick the run

Load only the sibling file(s) needed for this run:

- **No argument, no `ace/`**: core setup. Load [CORE.md](CORE.md) for Steps 1 to 4, then stop with tailored starter prompts.
- **Module name(s) or `full`**: run requested modules in table order (`full` runs [CORE.md](CORE.md) first if `ace/` is missing, then remaining modules).
- **No argument, existing `ace/`**: update after an Ace update. Load [UPDATE.md](UPDATE.md).

| Group | Module | Guide | Writes | Unlocks |
|---|---|---|---|---|
| Customize chat & reviews | `standards` | [STANDARDS.md](STANDARDS.md) | `ace/CODING_STANDARDS.md` | Project coding rules, trust boundaries, accepted risks |
| Customize chat & reviews | `settings` | [SETTINGS.md](SETTINGS.md) | `ace/config.json` | `autonomy`, `communication`, `review.require_other_model`, `pull_requests.max_added_lines`, `write_adrs` |
| Tickets & automation | `tickets` | [TICKETS.md](TICKETS.md) | `ticket_tracker`, labels, or `ace/TICKET_TRACKER.md` | Tickets, `ace-audit`, `ace-work-ticket`, spec checks |
| Tickets & automation | `cycle` | [CYCLE.md](CYCLE.md) | `ace/CYCLE.md` | Automated runners (CI, schedules, cloud agents) |

## Constraints

- Keep `AGENTS.md` and `CLAUDE.md` at the repo root, and project config in `ace/` (move any stray root `VERIFY.md` there).
- In a monorepo, follow [contract/PACKAGES.md](../ace-mode/shared/adapters/contract/PACKAGES.md): packages with their own checks or app get `PACKAGE/ace/VERIFY.md` (and `PACKAGE/ace/CODING_STANDARDS.md` when they have package-specific rules).
- Preserve existing content in files; add only what is missing or confirmed.
- Write only files for the chosen run; leave optional files absent so defaults from [contract/](../ace-mode/shared/adapters/contract/) and [config.schema.json](config.schema.json) apply.
- Write every required section from [contract/](../ace-mode/shared/adapters/contract/) using the headings in [templates/](templates/). For a built-in provider in [github/](../ace-mode/shared/adapters/github/), write only sections that differ from the provider. Keep providers inside the Ace skill folder.
- Write no CI or runner config files, and ask for no tokens or secrets. Pull requests work on GitHub with no setup.
