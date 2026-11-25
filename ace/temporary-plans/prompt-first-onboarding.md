# Plan: Prompt-first onboarding in `/ace-setup` and `/ace-help`

## Goal

Help new users understand and start using Ace quickly inside their own repo without memorizing internal concepts, file lists, or optional modules upfront.

## Settled Decisions

1. **Ending core `/ace-setup` (1A):** Stop cleanly after Step 4. Print `🎉 Ace is ready!` with completed files, check status, **3 concrete prompts tailored to the user's repo** (grounded in files, scripts, or checks found during the scan), and one short line pointing to `/ace-help` and optional `/ace-setup <module>` add-ons (`tickets`, `standards`, `settings`, `cycle`, or `full`). Remove the interactive optional-module picker from core setup. Keep `/ace-setup full` continuing straight into remaining modules.
2. **Guided tour in `/ace-help` (2A):**
   - Bare `/ace-help` reports what is active in the current repo in plain words (such as verification checks, tickets, coding standards, custom settings, or defaults with no `ace/` folder), shows a compact prompt-first cheat sheet, and offers a quick guided tour on request (for example `/ace-help tour` or "give me a tour").
   - Asking for a tour returns a **single-reply walkthrough**: one short, scannable guide covering 3 to 4 Day 1 workflows (plan, fix or build, review, optional add-ons) using real examples from the user's repo.
3. **Minimal `## Ace` block in `AGENTS.md` (3A):** Shrink "Reference: root agents section" in `skills/ace-setup/CORE.md` to 2 plain-English bullets under `<!-- added by ace -->` / `## Ace`:
   - Load `ace-mode` for every task (with the `Ace not loaded:` fallback check).
   - Stay read-only by default: answer questions, reports, and ideas without editing files; change files only when asked (or when the user confirms a proposal).
   - Move the missing-skill reinstall hint (`npx skills add tobimey/ace`) into `skills/ace-mode/SKILL.md` under `Requires` or `Constraints`, and drop the adapter, verify, config, ticket, PR, and monorepo bullets from `AGENTS.md` (since `ace-mode` already owns them once loaded).
4. **Updating existing `AGENTS.md` blocks in `/ace-setup` update mode (4A):** In `skills/ace-setup/UPDATE.md`, when an existing `<!-- added by ace -->` `## Ace` section contains the older, longer lines, offer to replace it with the new 2-bullet block (previewed in Step 1 before writing, skippable like any other update).

## Files to Update

- `skills/ace-setup/CORE.md`:
  - Replace "Finish & optional modules" with the clean finish (3 repo-tailored prompts + one-line mention of `/ace-help` and optional `/ace-setup <module>` add-ons; keep `/ace-setup full` continuation).
  - Replace "Reference: root agents section" with the 2-bullet `## Ace` block and remove the conditional ticket, PR, and monorepo lines.
- `skills/ace-setup/SKILL.md`:
  - Update "Pick the run" descriptions to remove references to the end-of-core optional module picker and to appending new `## Ace` lines per module.
- `skills/ace-setup/TICKETS.md`:
  - Remove the line in Finish that appends the ticket line to the root agents file.
- `skills/ace-setup/UPDATE.md`:
  - Detect an outdated `<!-- added by ace -->` `## Ace` block in Step 0, preview swapping it to the new 2-bullet block in Step 1, and apply the swap on confirm in Step 2.
- `skills/ace-mode/SKILL.md`:
  - Add the missing-skill reinstall hint (`npx skills add tobimey/ace`) next to the `Requires` / skill-loading constraint so nothing is lost when removed from `AGENTS.md`.
- `skills/ace-help/SKILL.md`:
  - Classify a tour request (e.g. "tour", "walkthrough", `/ace-help tour`) alongside bare help and specific questions.
  - Make bare help report active project setup in plain words and offer the guided tour.
  - Define the single-reply 3 to 4 step repo-tailored walkthrough for tour requests.
- `skills/ace-optimize-factory/AGENTS_FILE.md`:
  - Verify its reference to "Reference: root agents section" in `CORE.md` still aligns cleanly with the 2-bullet block.
- Docs (`README.md`, `docs/CONFIGURATION.md`, `docs/SKILLS.md`, `docs/AUTOMATION.md`):
  - Update any descriptions of `/ace-setup` finish, `/ace-help` tour, or the `## Ace` block written to `AGENTS.md`.

## Constraints & Verification

- Follow the "Keep skills short" rule in `AGENTS.md`: trim redundant wording and report before/after `wc -w` for every changed skill.
- Keep internal Ace jargon ("adapter", "contract", internal skill paths) out of user-facing setup and help output.
- Leave `.agents/skills/` and `.claude/skills/` untouched (source in `skills/` only).
- Verify per `ace/VERIFY.md` after implementation (diff review, doc consistency, and word counts).
