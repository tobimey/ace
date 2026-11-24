# Cycle module (`cycle`)

Describes automated runners (CI jobs, schedules, cloud agents) in `ace/CYCLE.md`, one decision per turn. Ace writes no runner config and asks for no tokens or secrets.

## Step 1 of 4 · 🔄 Automated runners

- **Why:** Tells Ace whether CI jobs, labels, schedules, or cloud agents start runs automatically, so Ace knows how to hand off the next step. Ace writes no CI config itself.
- **Question:** Does anything besides a person start Ace runs in this project? **A)** No, a person starts every run (recommended for now) · **B)** Yes, I have (or am setting up) a CI job, schedule, or cloud runner
- **Recommend:** **A)** Skip this until you actually wire up an automated runner.
- **On A:** write no `ace/CYCLE.md`, print `✅ All set! A person starts every run, so Ace will simply tell you the next step after each task.`, and stop (or continue in `full`).

## Step 2 of 4 · ⚡ Automated jobs & triggers

- **Why:** Lets Ace know what runs automatically and what trigger kicks off each job.
- **Supported automated jobs:** 🔍 **PR reviews**: runs once per pull request (e.g. on open) · 🛠️ **Ticket worker**: picks the next ready ticket and opens a pull request · 🛡️ **Scheduled audits**: audits chosen domains and files tickets
- **Question:** Which jobs will your runner start, and what triggers each one? **A)** PR reviews only (tell me the trigger, such as "when a PR opens") · **B)** PR reviews + Ticket worker (tell me the triggers) · **C)** Custom combination (name the jobs, audit domains if any, and triggers)
- **Recommend:** **A)** Automated PR reviews are the easiest and safest first job.

Handle job prerequisites cleanly as single follow-up questions only when triggered:

- **PR reviews**: message is `Review pull request #NUMBER and comment on it.` (once per PR, since `ace-babysit-pr` also pushes).
- **Ticket worker**: message is `Run ace-work-ticket.` (or `Run ace-work-ticket. Open the pull request as a draft.` when the runner reviews drafts and marks them ready itself). Needs a ticket tracker (run [TICKETS.md](TICKETS.md) first if missing). Note that the runner must start at most one ticket worker at a time (e.g. a `concurrency` group). Ask `autonomy` as in [SETTINGS.md](SETTINGS.md) if `ace/config.json` has no `autonomy` set.
- **Audits**: ask which domains. Each message is `Run ace-audit DOMAIN.` (e.g. `Run ace-audit security.`). Needs a ticket tracker (run [TICKETS.md](TICKETS.md) first if missing).

## Step 3 of 4 · 🤖 Runner environment differences

- **Why:** Automated runners sometimes have fixed prompts, restricted tokens, or post under a user account. Recording those differences prevents failed runs.
- **Question:** Does your runner differ from a local run in any of these ways? **A)** No, it runs just like a local session · **B)** Yes (tell me which: **Target** for fixed prompts, **Limits** for branches/secrets/tokens, or **Posting** when `gh` acts as a person)
- **Recommend:** **A)** Keep it simple unless your runner enforces one of those constraints.
- **On B:** capture each named difference for a `Runners` subsection per [contract/CYCLE.md](../ace-mode/shared/adapters/contract/CYCLE.md), starting its messages with `Runner: NAME.`:
  - **Target**: where the run finds its PR or ticket number (when fixed-prompt, message uses `the pull request this run was started for`).
  - **Limits**: allowed branches, secrets, and token permissions.
  - **Posting**: how the runner posts as itself (`Comment on a pull request` and `Reply to a review thread` sections) when `gh` acts as a person.

## Step 4 of 4 · ✅ Save automated cycle

- **Why:** Writes `ace/CYCLE.md` with your triggers and hand-offs so Ace coordinates cleanly with your runner.
- **Summary:** **Automated runs:** <list of jobs + triggers> · **Runner overrides:** <summary or "None"> · **File:** `ace/CYCLE.md`
- **Question:** Save `ace/CYCLE.md`? **A)** Yes, save · **B)** Adjust something first
- **Recommend:** **A)** You can update `ace/CYCLE.md` whenever your workflow changes.
- **On confirm:** write `ace/CYCLE.md` with every required section in [contract/CYCLE.md](../ace-mode/shared/adapters/contract/CYCLE.md) (writing hand-offs only where a runner needs something, such as a label). Check git tracking of `.agents/skills/`, `.claude/skills/`, and `skills-lock.json`.

Finish with this short checklist (setting none of it up yourself):

```markdown
🎉 **Automated cycle saved!**

**Before your first automated run, make sure your runner has:**
- 📦 Ace skills committed to git <("✅ Already tracked" | "⚠️ Please commit: <untracked paths>">
- 🔑 `gh` logged in (plus your ticket tracker CLI, if used)
- 🏷️ Optional: `ACE_MODEL` env var set to the model id so comments show which model wrote them
- 🧠 Tip: use a different model for reviews than for implementation (`review.require_other_model` in `ace/config.json` enforces this)
```
