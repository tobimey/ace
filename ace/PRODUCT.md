# Product

Who this project is for and where it is going. `ace-grill` reads it before it offers directions, and updates it after each pick. Change it freely.

## Users

New users discovering and setting up Ace.

## Goal

The one outcome "better" means right now.

Understand Ace quickly without memorizing its parts.

## Non-goals

What the project leaves alone, even when it would help.

Keep Ace as plain Markdown skills (no custom CLI, harness plugins, or CI runner configs) and stay GitHub-only.

## Directions

The direction picked for each scope, one line per scope.

- whole project: Zero-friction first run. Ace ships as a Claude Code plugin that updates itself and loads the router on its own, with no pasted line and no committed copy; other harnesses keep the manual path. (picked 2026-11-24)
- user experience: Crisp replies & natural shortcuts. Replace stacked, multi-skill reports with one short, scannable reply that highlights only what needs attention, and let users steer the pace in plain language (such as "quick fix", "just build it", or "build and open a PR") to chain steps and skip pauses on demand. (picked 2026-11-24)
- docs and onboarding: Progressive README and docs split. Cut README.md to a short, prompt-first landing page with Day 1 chat examples and a two-tier framing, and move the 17-skill, ace/ file, ticket, and runner reference into docs/. (picked 2026-11-25)
- mental model: Simplify the mental model. Present Ace around plain workflows instead of 17 skill names, separate user-edited ace/ files from agent-managed state, and align /ace-setup add-ons to those simpler buckets. (picked 2026-11-25)
- setup and help: Prompt-first onboarding in `/ace-setup` and `/ace-help`. End core `/ace-setup` with tailored prompts to try right away, upgrade `/ace-help` with a plain-word status and optional guided tour, and shorten the `## Ace` block written to `AGENTS.md`. (picked 2026-11-25)
