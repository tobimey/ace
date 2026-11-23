---
name: ace-help
description: Explains how Ace works, what it can do, and what is configured in the current project.
disable-model-invocation: true
---

# Ace help

Answer questions about Ace and inspect the current project's Ace setup. Done means the user has a clear, grounded answer and, when relevant, the exact prompt or command to run next, with every file left unchanged.

## Constraints

- Read only. Leave every file unchanged, and run only read-only checks. When the user wants an action, name the exact prompt or command to run next.
- Explain capabilities in plain words (what the user can say). Name a skill only when users run it directly (`/ace-setup`, `/ace-help`, `/ace-audit`, `/ace-garden`, `/ace-work-ticket`, `/ace-babysit-pr`) or when the user asks for all skill names. Keep internal routing details out of replies.
- Ground specifics in the installed Ace files and the current project rather than guessing.
- Keep scope to Ace usage, configuration, and current project setup. Point misbehaving-agent issues to `ace-optimize-factory` and work-in-progress status to asking "what's next".

## Where facts live

Read only what the question needs, relative to this file's folder (`../`) and the repo root:

- **Capabilities and routing**: `../ace-mode/SKILL.md`, and `../<skill>/SKILL.md` for details on one job.
- **Setup and modules**: `../ace-setup/SKILL.md` (`standards`, `tickets`, `cycle`, `settings`, or `full`).
- **Settings and defaults**: `../ace-setup/config.schema.json`.
- **Adapters and defaults**: `../ace-mode/shared/adapters/ADAPTERS.md` and `../ace-mode/shared/adapters/contract/`.
- **Project setup**: root `AGENTS.md` or `CLAUDE.md` (Ace section), `ace/` files and `ace/checks/`, `ace/config.json`, and any package `ace/` folders.

## Workflow

1. **Classify the request**:
   - **Bare help** (no specific question): run step 2, then give the context-aware overview in step 3.
   - **Specific question** (how Ace works, a setting, an adapter, a workflow, or what is configured here): read only the matching sources from "Where facts live", run step 2 when the answer depends on the current project, then answer directly in step 3.
2. **Inspect the project snapshot** (when needed): check `ace/`, `ace/checks/`, active values vs. defaults in `ace/config.json`, and the Ace section in the root agents file.
3. **Answer and stop**:
   - For **bare help**: show a short status line for this project (configured files and active settings, or that Ace is using defaults with no `ace/` folder), a compact prompt-first cheat sheet of what the user can ask Ace to do (plan, fix, build, review, babysit PRs, clean up, audit, explain, configure), 2 to 3 tailored next steps for this repo (such as `/ace-setup` when `ace/` is missing, or remaining modules like `/ace-setup tickets` and what they unlock), and ask what they need help with.
   - For a **specific question**: answer concisely with exact prompts or commands, noting any relevant setting or default from this project.
