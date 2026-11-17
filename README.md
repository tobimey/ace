`This project is in active development and not ready to use. Pre-Alpha expected by 18.11.2026.`

# Ace

Ace is an adaptable, agentic skills framework.

The new age of programming isn't … programming. It's probably not even engineering. Writing code is not just cheap; for many workflows it is largely delegated to agents. With Ace, the role shifts: less direct code authorship, more engineering of the factory and the inputs that the factory receives.

## Get started

1. Install Ace into your project with `npx skills add tobimey/ace`. This works the same in every harness. Ace installs as one set: its skills load each other, so install all of them.
2. Commit what it installed: `.agents/skills/`, `.claude/skills/`, and `skills-lock.json`. Then every teammate and every CI run uses the same Ace version, and CI needs no install step.
3. Start working. Say what you want, such as "fix the login redirect" or "review my changes", and `ace-mode` picks the skills. Ace needs no setup: it finds your checks in CI and your scripts, and works without a ticket tracker.
4. When you want Ace to know your project better, run `/ace-setup`. It turns on `ace-mode` in your `AGENTS.md` and writes `ace/VERIFY.md` with your checks, in a few minutes. Add more when you need it, one module at a time: `/ace-setup tickets`, `/ace-setup ci`, `/ace-setup standards`, `/ace-setup hosting`, or `/ace-setup settings`.
5. To update Ace, run `npx skills add tobimey/ace` again and commit. Your `ace/` files hold only your project's facts, and the GitHub providers update with Ace, so they need no change. Run `/ace-setup` once after updating from a version that copied the GitHub templates into `ace/`. It offers to shrink those files to what you changed.

This README writes skill commands as `/ace-setup`. In Codex, type `$ace-setup` instead.

## What models to use?

Use a model that scores above 40 on the [Artificial Analysis Intelligence Index](https://artificialanalysis.ai/models#intelligence). Ace skills are long, multi-step instructions that call each other, and weaker models skip steps or drop rules.

Review with a different model than the one that implemented the change. A model tends to miss the same mistakes in review that it made while writing the code.

## Supported harnesses

Ace supports Claude Code, Cursor, and Codex. The skills are plain Markdown and follow the Agent Skills format, so other harnesses may work too, but they are not tested yet and support is not guaranteed.

Ace ships no harness plugins yet. Plugins for Claude Code, Cursor, and Codex will come later, once Ace ships more than skills, such as hooks or agents. Until then, `npx skills add` installs the skills into the project, and the project commits them.

## Supported code hosts

In v1, Ace supports only GitHub, for tickets, pull requests, and runs started by GitHub Actions. GitHub is the only host Ace is tested on. The adapter files can describe another host, such as GitLab or Bitbucket, or another tracker, such as Linear or Jira, but that setup is not tested and support is not guaranteed.

Ace is also agnostic to the model you use if it is good enough. It also doesn't matter what type of project you are working on.

## Skill categories

Ace groups its skills into these categories. Every skill has its own folder in `skills/`, such as `skills/ace-review/`.

- Stage 1, plan: `ace-grill` interviews you until a plan is settled and writes it into a ticket. `ace-to-ticket` turns a plan or spec into one ticket or several sub-tickets, and opens every ticket in the shared Ace shape.
- Stage 2, implement: `ace-diagnose` finds and proves the root cause of a bug, `ace-implement` builds the plan test-first, `ace-verify` proves it works, and `ace-open-pr` opens the pull request. `ace-work-ticket` runs this stage with no person: it takes the next ready ticket, builds it, and opens a reviewed pull request, usually on a schedule.
- Stage 3, review: `ace-review` runs three checks on the change: spec (does it do what the ticket asked), standards (your coding standards), and code (logic, security, performance, and architecture). It fixes what the `review` settings allow, writes the rest as findings, and rates the Merge Danger. On a pull request it commits its fixes. On a local diff it leaves them uncommitted, and you commit.
- Stage 4, optimize: skills that improve the agentic system so it works better next time. `ace-optimize-factory` runs a retro on a session or fixes one named misbehaviour, `ace-agents-file` edits the agents file, and `ace-skill-optimizer` and `ace-create-skill` edit and create skills.

That is called the `ace cycle`. It's the core software cycle that drives the software development process. On top of these, Ace provides a few more skills:

- router: `ace-mode` picks the playbook for each message and runs its skills in order. It and `ace-unslop` are the only skills the agent sees on its own. Every other skill is hidden from the agent: `ace-mode` and other skills load it by path, and you run it as a slash command.
- setup: `ace-setup` writes the adapters, with a quick setup first and one module at a time after that.
- audit: `ace-audit` audits the whole codebase for the domains you pick: security, logic, performance, architecture, and health. `/ace-audit security` runs one domain, `/ace-audit` asks which and recommends all five. Each domain runs as its own pass and files at most three tickets by default, which feed into stage 2. It usually runs on a schedule.
- understand: `ace-explain` explains how code works, why it is built that way, or both for a change, and `ace-learn` teaches a topic over several sessions. `ace-explain-change` writes an explainer for a pull request, with a code walkthrough and a quiz, and posts it there. Run it by name, or add it to the CI step that runs your reviews.
- shared: skills that other skills load, never run on their own. `ace-adapters` says how skills read the adapters and what they use when one is missing. `ace-checks` holds the logic, security, performance, and architecture rules that both `ace-review` and `ace-audit` use. `ace-codebase-design` holds the deep-module vocabulary those rules and any design work use.
- tone: `ace-unslop` keeps the agent's writing clean and easy to follow.

## Local vs Cloud 

Some things will run in the cloud, some on a local machine. The trend likely moves toward more cloud execution. The system here is not built for one specific type of machine. When set up correctly, something running in the cloud can access an app the same way as local tooling.

## The ace cycle

You can call it a factory. You can call it a restaurant. You can call it a garden. Many terms match. This document uses the term **cycle**: software is rarely ever "done."

The cycle is a loop. It starts with an idea that forms into a plan. The plan gets implemented. The code gets verified, tested and reviewed. This is the inner loop.

## Adapters

Ace is generic. It's suitable for all sorts of software projects in whatever language. What matters is adapting it to project and team needs.

The skills are built in a way that they listen to your needs. These adapters live in `ace/` in your project. Each one is optional: without it, Ace uses a default, and `ace-setup` writes it when you want your own:

- `CODING_STANDARDS.md` is used in stages 2 and 3 to check that the code is written in a way that is consistent with your coding standards.
- `VERIFY.md` says how to prove a change works: the checks CI runs, how to start the app, and how to try each kind of change. `ace-verify` follows it in stage 2, and `ace-review` runs its checks in stage 3.
- `TICKET_TRACKER.md` says how to read, search, open, and update tickets, e.g. in Linear or Jira. It also says how the tracker shows the three ticket states. Every ticket an agent opens starts in `needs-dev`. A person reads it and sets it `ready`, unless the settings let the agent do it. `ace-work-ticket` claims a ready ticket and sets it `working`, or sends it back to `needs-dev` with a question when it gets stuck. For GitHub Issues you need no file: set `"ticket_tracker": "github-issues"`, and the states are the labels `ace:needs-dev`, `ace:ready`, and `ace:working`.
- `CODE_HOSTING.md` says how to open a pull request, comment on it, and find the tickets it closes, e.g. on GitLab or Bitbucket. On GitHub you need no file.
- `CYCLE.md` says what starts runs besides a person, such as a cloud agent on a schedule. By default a person starts every run and `ace-mode` names the next step. For GitHub Actions you need no file: set `"who_starts_runs": "github-actions"`, and `/ace-setup ci` writes the workflows. GitHub Actions then reviews a pull request as `review.runs` says, or when you add the label `ace:review`, a schedule runs `ace-work-ticket`, and another schedule runs `ace-audit`.

### Built-in providers

Ace ships the ticket tracker, code hosting, and cycle for GitHub inside the skills, in [skills/ace-adapters/github/](skills/ace-adapters/github/). You pick them in `ace/config.json` instead of copying them into your project, so they hold no project values and update with Ace. When you want one part different, such as an assignee on every ticket or your own pull request rules, write just that section in your `ace/` file. It replaces the provider's section with the same job, and the provider fills the rest. For a tool without a provider, the `ace/` file holds every section.

The adapters are yours. `ace-setup` writes a first draft of the ones you need, and from then on you change them as the project needs. Ace skills depend only on a few sections, listed with their defaults in [skills/ace-adapters/ADAPTERS.md](skills/ace-adapters/ADAPTERS.md). Keep those, under any heading, and the rest of each file is free. When a file or a section is missing, the skill uses the provider you picked, or else its default, and names the default in one line. For example, with no `VERIFY.md` it runs the checks your CI runs, and with no ticket tracker it writes a ticket into the reply. The first time `ace-verify` runs without `VERIFY.md`, it writes one from what it found.

In a monorepo, a package can have its own `ace/` folder with a `VERIFY.md`, plus a `CODING_STANDARDS.md` if the package has its own rules. `ace-setup` offers one for each package with its own checks or app, and you can add one yourself, such as `apps/web/ace/VERIFY.md`. Nothing needs to list it: for a changed file, Ace reads the root `ace/` folder plus every `ace/` folder between that file and the root. A change in a package runs the root checks and the package checks, and the root coding standards win on conflict. The glossary, ticket tracker, code hosting, and settings exist only once, at the root.

### Many repos (planned)

Not built yet. A company with many repos will keep one shared config in its own repo and point every project at it:

```json
{ "extends": "github:acme/ace-config#v1" }
```

The shared repo holds `config.json`, `CODING_STANDARDS.md`, and, for a tracker or code host without a built-in provider, `TICKET_TRACKER.md` and `CODE_HOSTING.md`. `VERIFY.md` stays in each project. `ace-setup` copies the shared files into `ace/shared/` and records the commit it copied, and the project commits that copy. So agents and CI never fetch config while they run, and a change to the company rules arrives as a diff you review. Running `ace-setup` again updates the copy.

The layers, from lowest to highest: Ace's defaults and providers, the shared config, the project's `ace/`, and a package's `ace/`. In `config.json`, a higher layer's key wins. In an adapter, a higher layer's section replaces the same section below it, and coding standards rules add up.

The glossary is the shared language between the human and the agent, so that nothing drifts. It is not an adapter file. It lives in a Glossary section of your root `AGENTS.md`, one line per term, because every session needs it and harnesses load that file into every session. Agents skip a lookup in a separate file more often than you'd think. `ace-grill` adds terms as a plan settles them. Once the section passes about 40 terms, or one word means different things in different parts of the project, the detail moves to `ace/GLOSSARY.md`, and `AGENTS.md` keeps the one-line entries.

Your root `AGENTS.md` (or `CLAUDE.md`) stays where it is, because harnesses load it from there into every agent session. `ace-setup` adds a short section to it that turns on `ace-mode`, points at the adapters, and tells the agent to change files only when asked to, plus the Glossary section. `ace-mode` is the router: for each message it picks a playbook, such as Build, Fix, or Review, and runs the Ace skills that playbook needs, in order. You state the goal, and `ace-mode` picks the skills. If the file doesn't exist yet, `ace-setup` writes a small draft for you to iterate on. If you have an `AGENTS.md` but no `CLAUDE.md`, it also creates a `CLAUDE.md` containing only `@AGENTS.md`, so Claude Code loads the same instructions.

## Settings

Adapters say how your project does a job. Settings say how your factory behaves: how much agents do on their own, and which optional features are on. They live in `ace/config.json`, which `/ace-setup settings` writes. Without the file, every setting has its default:

```json
{
  "$schema": "../.agents/skills/ace-setup/config.schema.json",
  "autonomy": "medium",
  "ticket_tracker": "none",
  "who_starts_runs": "person",
  "review": {
    "runs": ["after-implementing"],
    "agents": "one-for-all-checks",
    "fix_severities": ["blocker", "should-fix", "nit"]
  },
  "write_adrs": false,
  "max_tickets_per_audit_domain": 3
}
```

- `autonomy`: how much agents do without a person, in one setting. It sets `who_sets_ready` and `review.fixes`, unless you set those yourself:

  | `autonomy` | `who_sets_ready` | `review.fixes` |
  |---|---|---|
  | `low` | `person` | `none` |
  | `medium` | `person` | `simple-only` |
  | `high` | `planning-agents` | `all` |

- `ticket_tracker`: where tickets live. `none` writes a ticket into the reply. `github-issues` uses the built-in GitHub Issues tracker. `custom` uses your `ace/TICKET_TRACKER.md`.
- `who_starts_runs`: what starts an agent run besides a person. `person`, `github-actions` for the built-in GitHub cycle, or `custom` for your `ace/CYCLE.md`.
- `who_sets_ready`, optional: who moves a new ticket from `needs-dev` to `ready`. `person` keeps a person between every ticket and the agent that builds it. `planning-agents` lets `ace-grill` and `ace-to-ticket` set the tickets of a plan you approved ready. `any-agent` lets `ace-audit` do it too.
- `review`: how `ace-review` runs.
  - `runs`: when a review starts without you asking. `after-implementing` reviews the local diff right after a change is built. `pull-request-opened` and `pull-request-pushed` review in GitHub Actions, which lets a different model review. You can always ask for a review in chat or with the label `ace:review`.
  - `agents`: `one-for-all-checks` runs the spec, standards, and code checks in one agent. `one-per-check` gives each check its own fresh agent. Fixes are always made by one agent.
  - `fixes`, optional: `none` changes no file. `simple-only` fixes what has one clearly correct edit. `all` also picks a fix when several are reasonable. Spec and architecture findings, and fixes that change a product decision, a public contract, or stored data, always stay findings.
  - `fix_severities`: which severities get fixed, from `blocker`, `should-fix`, and `nit`. The rest stay findings.
- `write_adrs`: when `true`, `ace-grill` records each hard-to-reverse decision as an ADR in `ace/adrs/`, and `ace-explain` reads them when you ask why.
- `max_tickets_per_audit_domain`: the most tickets one audit pass files for one domain.

The `$schema` line points at the schema in the installed Ace, so your editor checks the values and explains each setting. A missing file or setting uses the default, so a new Ace version needs no change to the file.

## Credits

Ace builds on ideas and skills from these projects:

- [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock (MIT). the retro in `ace-optimize-factory` is adapted from his `retro` skill, `ace-learn` from his `teach` skill, `ace-diagnose` from his `diagnosing-bugs` skill, `ace-codebase-design` from his `codebase-design` skill, the architecture domain of `ace-audit` follows his `improve-codebase-architecture` survey, and `ace-grill` and `ace-to-ticket` follow his grilling and ticket-slicing workflows.
- [pstack](https://cursor.com/marketplace/cursor/pstack) by Lauren Tan (MIT, [mirror](https://github.com/backnotprop/pstack)). `ace-mode` and the playbook-style skills take after its approach. `ace-explain` is adapted from its `how`, `why`, and `teach` skills, and `ace-unslop` is adapted from its `unslop` skill.
- [explain-diff](https://gist.github.com/geoffreylitt/a29df1b5f9865506e8952488eac3d524) by Geoffrey Litt. `ace-explain-change` follows its idea of explaining a change with background, intuition, a code walkthrough, and a quiz.

The license notices of these projects are in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## License

Ace is under the MIT License. See [LICENSE](LICENSE).
