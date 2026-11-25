# Plan: Simplify the Ace mental model

## Goal

Make Ace easy for new users to understand without memorizing 17 skill names or 10 `ace/` files, while keeping all existing file paths and `/ace-setup` module commands backwards-compatible.

## Settled decisions

1. **Five plain workflows first, 17 skills under the hood**
   - Present Ace around **5 plain workflows**: **Plan**, **Build & fix**, **Review**, **Babysit PRs**, and **Clean up & audit**, with a short note for **Explain** and **Improve the setup (Optimize)**.
   - Remove the "17 skills" framing from [README.md](../../README.md) and lead with the 5 workflows.
   - Reorganize [docs/SKILLS.md](../../docs/SKILLS.md) around the 5 workflows (plus the short note for Explain and Optimize, and pace shortcuts) and move the full 17-skill breakdown into a collapsed `<details>` or bottom "Under the hood" reference section.

2. **Group `ace/` files into three buckets (no disk moves)**
   - Keep all `ace/` file paths unchanged on disk.
   - Reorganize [docs/CONFIGURATION.md](../../docs/CONFIGURATION.md) into three clear buckets instead of one flat 10-file table:
     1. **Files you edit**: `VERIFY.md`, `CODING_STANDARDS.md`, `config.json` (plus optional `checks/`).
     2. **Automation files**: `TICKET_TRACKER.md`, `CYCLE.md` (linking to [docs/AUTOMATION.md](../../docs/AUTOMATION.md)).
     3. **Agent-managed state** (collapsed `<details>` or short footer note): `PRODUCT.md`, `GLOSSARY.md`, `adrs/`, `temporary-plans/`.
   - Reflect the same framing in [README.md](../../README.md) ("Scale when ready").

3. **Group `/ace-setup` add-ons into two buckets (keep module names)**
   - Keep the 4 module names (`standards`, `settings`, `tickets`, `cycle`) and `full` so existing commands keep working.
   - Group them under two clear buckets in [skills/ace-setup/SKILL.md](../../skills/ace-setup/SKILL.md), [skills/ace-setup/CORE.md](../../skills/ace-setup/CORE.md), [README.md](../../README.md), and `docs/`:
     - **Customize chat & reviews**: `standards`, `settings`
     - **Tickets & automation**: `tickets`, `cycle`

4. **Align `/ace-help` with the simpler mental model**
   - Update [skills/ace-help/SKILL.md](../../skills/ace-help/SKILL.md) so bare help presents the same 5 workflows (plus Explain/Optimize note and pace shortcuts) and shows only user-edited `ace/` files in its default status line, keeping agent-managed state hidden unless the user asks about it.

## Files to update

- `README.md`
- `docs/SKILLS.md`
- `docs/CONFIGURATION.md`
- `skills/ace-help/SKILL.md`
- `skills/ace-setup/SKILL.md`
- `skills/ace-setup/CORE.md`

## Constraints & verification

- Follow `AGENTS.md` "Keep skills short": prefer editing/merging/cutting over adding text in `skills/`, and report `wc -w` before and after for each changed skill file.
- Do not edit `.agents/skills/` or `.claude/skills/` by hand.
- Verify per `ace/VERIFY.md` after edits.
