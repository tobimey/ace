# Glossary

The shared language of this project. Use these terms in code, tickets, and conversation. One name per concept.

- **you**: the agent writing code in this project
- **I, me, myself**: the developer of Ace driving this repository
- **the user**: a developer who uses Ace to build software
- **project**: a codebase or repository
- **Ace cycle**: the loop of plan, implement, review, and optimize
- **Ace source**: the Ace product this repository builds: `skills/` and `README.md`. "Ace" alone means this.
- **installed Ace**: the copies and adapters this repository runs on: `.agents/skills/`, `.claude/skills/`, `skills-lock.json`, `ace/`
- **Ace plugin**: the one plugin that ships every Ace skill. Claude Code and Codex install it from this repo's own marketplace. It also has a Cursor manifest for Cursor's marketplace. Until Ace is listed there, Cursor and every other harness install the skills with `npx skills add`, and each harness uses only one install method.
- **explainer**: the Markdown explanation of a change that `ace-explain` writes, with Background, Intuition, Code, Quiz, and a glossary. It goes into a PR comment, or into the chat when there is no PR.
- **ticket states**: the states a ticket moves through in the Ace cycle: `needs-dev` (a person must look at it), `ready` (an agent may work it, set only by a person), `working` (`ace-work-ticket` claimed it). The ticket tracker adapter says how the tracker shows each one.
- **custom check**: a check a project adds as `ace/checks/<name>.md`, with Find, Drop, and Severity sections like an `ace-checks` domain file. `ace-review` runs it as its own check and `ace-audit` as its own domain, and its findings take the file name as their category. Not: custom rule, which is a coding standard.
- **settled plan**: what `ace-grill` ends with once no decision is left open: each decision and its answer. Grill hands it to `ace-to-ticket`, which writes it into a ticket, unless the user picks no ticket or the project has no ticket tracker.
