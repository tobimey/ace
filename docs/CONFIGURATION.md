# Configuration and project files

[Back to README](../README.md)

The files in `ace/` tell Ace how your project works. Core setup (`/ace-setup`) writes `VERIFY.md`, which is enough for interactive chat and default reviews. Every other file is optional: without it, Ace falls back to the default listed below (and stops in unattended runs when a tracker or runner config is missing), naming any default it used in one line of its reply.

The files are yours: `ace-setup` writes a first draft, and you change them as the project needs. Ace reads only a few sections, finds each by its job under any heading, and leaves the rest free.

## Project files

Every file lives under `ace/`, grouped by who edits it.

### Files you edit

Core setup writes `VERIFY.md`. Add the others with `/ace-setup standards` or `/ace-setup settings` (the **Customize chat & reviews** add-ons), or create them by hand.

| File | What it says | Setup command | Without it |
|---|---|---|---|
| `VERIFY.md` | How to prove a change works: the checks that must pass, how to start the app, and how to try each kind of change, with the fastest tool made for agents, such as Vercel's `agent-browser`, before slower ones like a browser MCP. `ace-verify` follows it, and `ace-review` runs its checks. | `/ace-setup` (core) | Runs the checks your CI runs, plus lint, test, or build scripts CI skips. Starts the app with your dev script. |
| `CODING_STANDARDS.md` | Your coding rules, which review and audit check against, plus optional sections: paths to skip, parties you trust, risks the team accepts, and packages whose major only a person bumps. | `/ace-setup standards` | The rules in [the template](../skills/ace-setup/templates/CODING_STANDARDS.md). No party is trusted, no risk is accepted. |
| `config.json` | How much agents do on their own and how they talk to you. See [Settings](#settings). | `/ace-setup settings` | The defaults in the schema. |
| `checks/` | Optional custom checks, one file each, such as `checks/ACCESSIBILITY.md`. Each says what to find, what to drop, and how severe a finding is. `ace-review` runs each as a check, `ace-audit` as a domain, and `ace-garden` as a topic. Single rules go in `CODING_STANDARDS.md`. | You, from [the template](../skills/ace-setup/templates/CHECK.md) | Only the built-in checks run. |

Your own pull request rules go in your pull request template or your `AGENTS.md`.

### Automation files

Add these when you connect a ticket tracker or unattended runners (**Tickets & automation** add-ons). See [Tickets and automation](AUTOMATION.md) for ticket states, model attribution, and runner prompts.

| File | What it says | Setup command | Without it |
|---|---|---|---|
| `TICKET_TRACKER.md` | How to read, search, open, and update tickets in a tracker such as Linear or Jira, and how it shows the [ticket states](AUTOMATION.md#ticket-states). GitHub Issues needs no file: set `"ticket_tracker": "github-issues"`, and write a file only to override a part, such as an assignee on every ticket, or a GitHub project with Priority and Size fields. | `/ace-setup tickets` | No tracker: Ace writes each ticket into the reply. |
| `CYCLE.md` | What starts runs besides a person, such as a CI job or a scheduled cloud agent, the message each run gets, and, for a runner that differs from a local run, how it finds its pull request or ticket, what it must not touch, and how it posts when `gh` there acts as a person. Ace writes no runner config: you set up the runner. | `/ace-setup cycle` | A person starts every run, and `ace-mode` names the next step. |

### Agent-managed state

Ace creates and updates these files on its own as you plan and work. You can read or edit them anytime, and you do not need to set them up.

<details>
<summary>Show agent-managed files in <code>ace/</code></summary>

| File | What it says | Who writes it | Without it |
|---|---|---|---|
| `PRODUCT.md` | Who the product is for, the goal "better" means right now, what it leaves alone, and the direction picked for each part. `ace-grill` ranks directions against it. | `ace-grill`, the first time you pick a direction | `ace-grill` asks for the users, goal, and non-goals. |
| `GLOSSARY.md` | Every project term with its detail, once the core glossary in `AGENTS.md` outgrows it. See [Glossary](#glossary). | `ace-grill` proposes it | The core glossary in `AGENTS.md`. |
| `adrs/` | Hard-to-reverse decisions, one ADR each. `ace-implement` and `ace-explain` read them whenever the folder exists. | `ace-grill`, when `write_adrs` is on | No ADRs. |
| `temporary-plans/` | Untracked markdown plans for work bigger than `S` when no ticket tracker is configured, so Plan and Implement run in separate sessions. `ace-implement` deletes the plan file after `ace-verify` passes. | `ace-grill` | Plans stay in chat (or tickets when a tracker is configured). |

</details>

## Settings

Settings in `ace/config.json` say how much agents do on their own and how they talk to you. A missing file or setting uses its default, so a new Ace version needs no change to the file. The `$schema` line lets your editor check the values and explain each setting.

```json
{
  "$schema": "../.agents/skills/ace-setup/config.schema.json",
  "autonomy": "medium",
  "communication": "code",
  "ticket_tracker": "github-issues",
  "review": { "require_other_model": false },
  "write_adrs": false
}
```

| Setting | Values and meaning |
|---|---|
| `autonomy` | `low`: a person sets every ticket ready, reviews fix nothing, and a ticket `ace-work-ticket` rejects waits for a person. `medium` (default): reviews also fix what has one clearly correct fix. `high`: tickets from a plan you approved go ready on their own, reviews pick a fix when several are reasonable, and `ace-work-ticket` closes a ticket it rejects. Tickets from `ace-audit` still wait for a person. Spec and architecture findings, and fixes that change a product decision, a public contract, or stored data, always stay findings. |
| `communication` | `code` (default): refer to files, lines, symbols, and code as needed. `product`: speak in user-facing behavior, flows, and glossary terms in chat replies and pull request explainers, omitting file paths, line numbers, symbol names, code snippets, and raw stack traces unless you ask. Posted pull request review comments, commits, audit tickets, and `ace/` files keep code references for agents. |
| `ticket_tracker` | `github-issues` uses the built-in GitHub Issues tracker. Leave it out for another tracker, described in `ace/TICKET_TRACKER.md`, or for none. |
| `review.require_other_model` | `true`: a session never reviews a change it built, and gives you the line to start the review on another model, such as a new session or your runner. `false` (default): it reviews on request and adds a tip to use another model. |
| `write_adrs` | `true`: `ace-grill` records each hard-to-reverse decision as an ADR in `ace/adrs/`. Default `false`. |

Everything else you say in the message, such as `"review this with one agent per check"`, `"audit security, up to 5 tickets"`, or, for a runner, `Run ace-work-ticket. Open the pull request as a draft.`

## Monorepos

A package can have its own `ace/` folder with a `VERIFY.md`, and a `CODING_STANDARDS.md` for its own rules, such as `apps/web/ace/VERIFY.md`. `ace-setup` creates one for each package with its own checks or app. Nothing lists them: for a changed file, Ace reads the root `ace/` folder plus every `ace/` folder between that file and the root. A change runs the root and package checks, and the root coding standards win on conflict. The glossary, ticket tracker, and settings exist only at the root.

## Glossary

The glossary is the shared language between you and the agent. Its core is a Glossary section in your root `AGENTS.md`, one line per term, up to about 25, because harnesses load that file into every session. `ace-grill` adds terms as plans settle them. Once the core outgrows that, or one word means different things in different parts of the project, it proposes a full `ace/GLOSSARY.md` and keeps the terms you pick in the core.
