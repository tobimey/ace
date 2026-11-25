# Tickets module (`tickets`)

Connects Ace to the project's ticket tracker, one decision per turn. Path A (GitHub Issues) has 4 steps, path B (another tracker) has 2.

## Step 1 · 🎫 Choose your ticket tracker

Inspect the git remote silently so you know whether the repo is on GitHub.

- **Why:** Connects Ace to your tracker so plans, audits, and autonomous runs can read and create tickets directly instead of printing them in chat.
- **Question:** Where do tickets live for this project? **A)** GitHub Issues (built-in support via `gh` CLI) · **B)** Linear · **C)** Jira · **D)** Another tracker (name it)
- **Recommend:** **A)** when this repo is on GitHub (otherwise pick the tracker your team uses).

## Path A: GitHub Issues

### Step 2 of 4 · 🏷️ Enable GitHub Issues & labels

- **Why:** Ace uses four labels (`ace-created`, `ace:needs-human`, `ace:ready`, `ace:working`) to show who opened a ticket and whose turn it is.
- **What will happen:** Set `ticket_tracker: "github-issues"` in `ace/config.json` · Create the 4 Ace labels in this repository via `gh label create`
- **Question:** Set up GitHub Issues and create the labels? **A)** Yes, apply and continue to Step 3 · **B)** Skip creating labels (only update `ace/config.json`)
- **Recommend:** **A)** The labels let you filter Ace tickets and mark which ones are ready to work.
- **On confirm:** create `ace/config.json` from [templates/config.json](templates/config.json) (setting `<SCHEMA>` as [SETTINGS.md](SETTINGS.md) says) if missing, set `"ticket_tracker": "github-issues"`, and run `gh label create ace-created`, `gh label create ace:needs-human`, `gh label create ace:ready`, and `gh label create ace:working` (unless skipped).

### Step 3 of 4 · 👤 Default ticket assignee

- **Why:** Decides whether new Ace tickets stay unassigned or automatically assign to a default person.
- **Question:** Should new tickets get a default assignee? **A)** No, leave new tickets unassigned (recommended) · **B)** Yes, assign to `<gh api user --jq .login>` (or another username)
- **Recommend:** **A)** Unassigned tickets stay clean for team triage.
- **On B:** write `ace/TICKET_TRACKER.md` with a `Defaults` section naming the assignee.

### Step 4 of 4 · 📊 GitHub Project Priority & Size fields

- **Why:** Optionally adds new Ace tickets to a GitHub Project and sets Priority and Size fields automatically.
- **Question:** Connect a GitHub Project with Priority and Size fields? **A)** No, skip this (recommended) · **B)** Yes, pick a GitHub Project
- **Recommend:** **A)** Tickets work fine without a GitHub Project; you can add it later.
- **On B:** run `gh project list --owner OWNER`, ask which project in one follow-up turn, look up `<ORG>`, `<PRIORITY_FIELD_ID>`, and `<SIZE_FIELD_ID>` using the lookup command in [templates/GITHUB_PROJECT_FIELDS.md](templates/GITHUB_PROJECT_FIELDS.md) (omitting missing fields), preview, and append that template section to `ace/TICKET_TRACKER.md` (creating it if missing).

## Path B: Another tracker

Inspect available MCP tools, CLIs, or APIs silently. Draft the tracker instructions following every section in [contract/TICKET_TRACKER.md](../ace-mode/shared/adapters/contract/TICKET_TRACKER.md), using [github/TICKET_TRACKER.md](../ace-mode/shared/adapters/github/TICKET_TRACKER.md) as the model. Leave `ticket_tracker` out of `ace/config.json`.

### Step 2 of 2 · 🔌 Confirm `<tracker>` setup

- **Why:** Saves how Ace reads, searches, opens, and updates tickets in `<tracker>` so every skill uses the same workflow.
- **What I found:** **Connection:** <MCP server / CLI / API> · **States:** <how `needs-human`, `ready`, and `working` map in `<tracker>`> · **File:** `ace/TICKET_TRACKER.md`
- **Question:** Save this ticket tracker configuration? **A)** Yes, save · **B)** Adjust something (tell me what to change)
- **Recommend:** **A)** You can refine `ace/TICKET_TRACKER.md` anytime.

## Finish

Print a short `🎉 Tickets ready!` summary (or continue to the next module in `full`).
