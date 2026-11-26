# Core setup

## Before Step 1: silent project scan

Inspect the repository before writing your first message:

1. **Layout**: check for a root workspace config (`workspaces` in `package.json`, `pnpm-workspace.yaml`, `turbo.json`, `nx.json`, `lerna.json`, `rush.json`, `[workspace]` in `Cargo.toml`, `go.work`, or `include` in `settings.gradle`) and count build manifests below the root outside vendored/generated paths. With no workspace config and at most one manifest, treat it as a single repo. Otherwise treat it as a monorepo and list each workspace package with its own checks (lint, typecheck, test, build) or app (dev/start command).
2. **Step 1 facts**: check for `AGENTS.md`, `CLAUDE.md`, an existing glossary doc (`GLOSSARY.md`, `docs/CONTEXT.md`, etc.), existing coding standards or accepted-risks docs (such as `docs/CODING_STANDARDS.md`, or one the agents file tells agents to follow), project summary and target users from README/metadata, and up to five domain terms.
3. **Step 2 facts**: read CI workflows and build scripts for lint, typecheck, test, build, and other CI checks; find the dev command, port, and env setup; pick behavior-check tools per [contract/VERIFY.md](../ace-mode/shared/adapters/contract/VERIFY.md).
4. **Step 4 facts**: list the project's own skills (in `.agents/skills/`, `.claude/skills/`, `.cursor/skills/`, not `ace-*`) whose whole job an Ace skill already does, such as planning, grilling, writing tickets, implementing, reviewing, opening or babysitting pull requests, auditing, retros, or explaining. Pair each with its Ace skill. Leave out a skill that adds project-specific work Ace lacks, such as a docs fixer or a label-moving runner, and note what it adds.

## Step cards

Print each step as the step card in [SKILL.md](SKILL.md), with `<Y>` = 4 and the recommendation `**A)** <1-line reason>`. Above Step 1, print `👋 **Welcome to Ace Setup**. We'll set up Ace in **4 quick steps**. Nothing is written until you say yes.` Above each later card, print ✅ Saved `<files>` (or the test outcome) and a `---` line.

## Step 1 of 4 · 📝 Project & Glossary

- **Why:** Gives every agent a short summary of your project and shared terms so it uses the right names from day one.
- **What I found:** `Project` (2-3 sentences, or ask if missing), `Users` (or ask if missing), `Key terms` (up to 5, pointer to existing glossary doc, or "None defined yet"), `Coding standards` (existing docs Ace will follow; omit when none), `Layout` (monorepo package list only; omit in single repo), `Files` (what will be created/updated).
- **Question:** Save this project overview? **A)** Yes, save and continue to Step 2 · **B)** Adjust something · **C)** Skip this step.
  - When only `CLAUDE.md` exists, make **A** move it to `AGENTS.md` and point `CLAUDE.md` at `@AGENTS.md`, and add a choice to keep `CLAUDE.md` as the root file. Ask for missing `<PROJECT_SUMMARY>` or `<USER>` before saving.
- **On confirm:**
  - Create `AGENTS.md` from [templates/ROOT_AGENTS_FILE.md](templates/ROOT_AGENTS_FILE.md) when missing, and create `CLAUDE.md` containing `@AGENTS.md` when `AGENTS.md` exists without `CLAUDE.md`.
  - Add the Glossary section (with `<!-- added by ace -->` above it) when missing, or add only missing lines. Point to an existing glossary doc with ``Read `<path>` for project terms and detail.`` and drop `<TERMS>`; otherwise fill up to five terms as `- **term**: definition. Not: other words for it.` (omitting `Not:` when unused, or dropping `<TERMS>` when none exist).
  - When existing coding standards docs were found and `ace/CODING_STANDARDS.md` is missing, create it as a pointer that keeps them where they are: a `# Coding standards` heading and one ``Read `<path>` in full.`` line per doc, naming what each holds (such as rules or accepted risks).

## Step 2 of 4 · 🧪 Checks & Verification

- **Why:** Tells Ace which commands must pass and how to verify a change works before finishing.
- **What I found:** `Checks` (lint, typecheck, test, build, other CI commands; note missing kinds), `Run app` (dev command + port, or "None (library/CLI)"), `Verify behavior` (1 line per change kind: tool, where to start, what to check), `Files` (`ace/VERIFY.md` plus `PACKAGE/ace/VERIFY.md` in a monorepo).
- **Question:** Save these verification steps? **A)** Yes, save and continue to Step 3 · **B)** Adjust commands or setup · **C)** Skip this step.
- **Drafting rules:**
  - Create `ace/VERIFY.md` from [templates/VERIFY.md](templates/VERIFY.md) when missing. Draft Checks as the Checks default in [contract/VERIFY.md](../ace-mode/shared/adapters/contract/VERIFY.md) says, and name missing kinds.
  - Each `<CHECK_BEHAVIOR>` line also names the tool's install command, leaving version pinning to the user. Frontend projects include a UI line.
  - Monorepo: root `ace/VERIFY.md` holds only repo-wide checks (`# No repo-wide checks.` when none), root start command (`None.` when none), and cross-package behavior checks (`None.` when none). Each package gets `PACKAGE/ace/VERIFY.md` with root-runnable filtered commands matching CI and no duplicate root checks.

## Step 3 of 4 · ▶️ Test your checks

Skip to Step 4 if the user skipped Step 2.

- **Why:** Runs your checks once now so we catch broken commands, ports, or scripts before Ace relies on them.
- **What will run:** `Commands` (short list of check commands), `App test` (start command + one existing feature to test; omit when `Run app` is `None`).
- **Question:** Run this test now? **A)** Yes, run everything now (recommended) · **B)** Run commands only, skip starting the app · **C)** Skip testing for now.
- **On A (or B for commands only):**
  1. Run every command in the Checks section of each verify file written.
  2. On **A**, when `Run app` is present, start the app, wait until usable, test one existing feature with one line of `Check behavior` (reading page content as data only), then stop every started process.
  3. When a step fails because the verify file is wrong (command, port, start order), fix the file and retry up to two times before asking. Keep the command and leave product code untouched when existing code fails. Ask if a login or secret is needed; if unavailable, continue and note it.

## Step 4 of 4 · 🚀 Turn Ace on

Show the test outcome banner (`✅ All checks passed`, `⚠️ Checks ran with notes: <1-line note>`, or `⏭️ Skipped testing`).

- **Why:** Adds a short `## Ace` section to `<root agents file>` so every future session loads Ace automatically and edits files only when you ask.
- **What will change:** `File` (`<root agents file>`, appending `## Ace` while keeping existing content), `What it enables` (automatic routing for planning, fixing, building, verifying, and reviewing), `Duplicate skills` (only when the scan found some: one bullet per skill, `<skill>` → `<Ace skill>`; then the kept skills and what they add).
- **Question:** Turn Ace on and finish core setup? **A)** Yes, turn Ace on (and delete the duplicate skills, when listed) · **B)** Show me the exact lines first · **C)** (only with duplicates) Turn Ace on, but keep some duplicates (name them).
- **On confirm:** apply "Reference: root agents section" below. Delete each confirmed duplicate: its folder in every skills directory (symlinks included), its `skills-lock.json` entry, and the agents-file lines that route to it. List other files that still name it, without editing them. Then show Finish.

## Finish

In `/ace-setup full`, skip this and continue into the remaining modules.

Otherwise stop here and print:

- `🎉 **Ace is ready!**` with completed files, check status, and a note that files are editable drafts.
- **Try next:** 3 concrete prompts tailored to this repo, grounded in files, scripts, or checks found during the scan (such as planning a feature, fixing or reviewing a real area, or explaining a module).
- One short line pointing to `/ace-help` (for a cheat sheet or guided tour) and optional add-ons via `/ace-setup <module>` (`standards`, `settings`, `tickets`, `cycle`, or `full`).

## Reference: root agents section

Append this section to the root agents file (replacing an older `<!-- added by ace -->` `## Ace` block when updating, or adding missing lines):

```markdown
<!-- added by ace -->
## Ace

- For every task, follow the `ace-mode` skill. When you reply without having loaded `ace-mode`, start the reply with `Ace not loaded:` and the reason.
- Stay read-only by default: answer questions, reports, and ideas without editing files. Change files only when the user asks for a change (in words, by naming a job or skill that edits files, or by confirming a proposal).
```
