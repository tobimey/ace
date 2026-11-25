---
name: ace-help
description: Explains how Ace works, what it can do, and what is configured in the current project.
disable-model-invocation: true
---

# Ace help

Answer questions about Ace and inspect the current project's Ace setup. Done means the user has a clear, grounded answer and, when relevant, the exact prompt or command to run next.

## Constraints

- Read only, including any checks you run. Name the exact prompt or command when the user wants an action.
- Explain capabilities in plain words. Name a skill only for direct commands (`/ace-setup`, `/ace-help`, `/ace-audit`, `/ace-garden`, `/ace-work-ticket`, `/ace-babysit-pr`) or when asked. Keep internal jargon (adapter, contract, routing, skill paths) out of replies.
- Ground specifics in installed Ace files and this repo. Keep scope to Ace usage, settings, and setup; point agent issues to `ace-optimize-factory` and work status to asking "what's next".

## Where facts live

Read only what the question needs, relative to this file (`../`) and the repo root:

- **Capabilities and routing**: `../ace-mode/SKILL.md`, and `../<skill>/SKILL.md` for one job.
- **Setup and modules**: `../ace-setup/SKILL.md` (`standards`, `settings`, `tickets`, `cycle`, or `full`).
- **Settings and defaults**: `../ace-setup/config.schema.json`.
- **Adapters and defaults**: `../ace-mode/shared/adapters/ADAPTERS.md` and `../ace-mode/shared/adapters/contract/`.
- **Project setup**: root `AGENTS.md`/`CLAUDE.md` (`## Ace`), `ace/`, `ace/checks/`, `ace/config.json`, and package `ace/` folders.

## Workflow

1. **Classify**: **bare help** (no question) or **tour** (`"tour"`, `"walkthrough"`, `/ace-help tour`) runs step 2 then 3; a **specific question** reads only matching sources above, runs step 2 if project-dependent, then answers in step 3.
2. **Inspect the project** (when needed): check `ace/`, `ace/checks/`, `ace/config.json` vs. defaults, the root `## Ace` section, and (for a tour) a few repo files or scripts for real examples.
3. **Answer and stop**:
   - **Bare help**:
     - **Status** in plain words: active features (verification checks, coding standards, custom settings, custom checks, tickets, automation), or defaults with no `ace/` folder. Omit agent-managed state (`PRODUCT.md`, `GLOSSARY.md`, `adrs/`, `temporary-plans/`) unless asked.
     - **Cheat sheet**: the **5 workflows** (**Plan**, **Build & fix**, **Review**, **Babysit PRs**, **Clean up & audit**), one line for **Explain** and **Optimize**, and pace shortcuts (`"just build it"`, `"quick fix ..."`, `"... and open a PR"`).
     - **Next**: 2 to 3 tailored steps (`/ace-setup` if `ace/` is missing, or unset modules) plus a one-line tour offer (`/ace-help tour` or `"give me a tour"`).
   - **Tour**: one short, scannable walkthrough in a single reply covering 3 to 4 Day 1 workflows (**Plan**, **Build or fix**, **Review**, and **Optional add-ons**) using real repo examples, ending with one prompt to try first.
   - **Specific question**: answer concisely with exact prompts or commands, noting relevant project settings or defaults.
