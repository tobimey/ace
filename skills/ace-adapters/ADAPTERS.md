# Adapter contract

The adapters in `ace/`, and the glossary in the root agents file, belong to the project. Change them freely. Ace skills depend only on the sections below. Each section does the job named here. Its heading may differ, since skills find a section by its job. Everything else in an adapter is free.

For the ticket tracker and code hosting, Ace ships built-in providers for GitHub in [github/](github/). A provider fills every section of its adapter, and the project selects it in `ace/config.json` instead of copying it. A file in `ace/` is needed only for a tool without a provider, or to replace single sections of one.

Every section has a default. A skill uses it when neither the file nor a provider has the section, as [SKILL.md](SKILL.md) says. `ace-setup` selects a provider or writes an adapter to replace the defaults with what this project does.

**GitHub** in a default means `git remote get-url origin` points at github.com and `gh auth status` succeeds. A default that needs GitHub does not fit any other project.

## Package folders

In a monorepo, a package can have its own `ace` folder, such as `apps/web/ace/`. It holds only `VERIFY.md` and `CODING_STANDARDS.md`. For a path, an adapter is the root file in `ace/` plus the same file in each `ace` folder between that path and the repo root. A package file adds to the root one:

- `VERIFY.md`: run the checks of the root file and of every package file. Start the app and try a behavior as the nearest file with that section says.
- `CODING_STANDARDS.md`: the rules of all files apply. The root file wins on conflict.

No file lists the package folders. A skill finds them from the paths it works on: for a diff, walk up from each changed path; for the whole repo, run `git ls-files '*/ace/VERIFY.md' '*/ace/CODING_STANDARDS.md'`.

The glossary, ticket tracker, code hosting, cycle, and settings exist only at the root.

## Shared config (planned)

Not built yet, so no skill reads it. A company with many repos will set `extends` in `ace/config.json` to a shared config repo. `ace-setup` will copy its `config.json`, `CODING_STANDARDS.md`, `TICKET_TRACKER.md`, and `CODE_HOSTING.md` into `ace/shared/` at a recorded commit, and the project commits the copy. The layers, from lowest to highest: Ace's defaults and providers, `ace/shared/`, the project's `ace/`, and a package's `ace/`. A higher layer's setting or section replaces the one below it. Coding standards rules add up.

## Glossary

The project's terms, in two tiers. Only the root has a glossary, also in a monorepo.

- **Glossary section of the root agents file.** Harnesses load that file into every session, so every agent has the terms without looking them up. It holds one line per term: `- **term**: what it means here. Not: other words for it.` It leaves out words a senior engineer already knows. A term's one-line definition lives only here.
- **`ace/GLOSSARY.md`, optional.** It is free form and holds what does not fit on one line: how terms relate, examples, open questions, a section per bounded context. It exists once the section passes about 40 terms, or once one word means different things in different parts of the project. The section then keeps every one-line entry and adds a line that points at this file.

Skills use the terms from the root agents file, and read `ace/GLOSSARY.md` when it exists and they need the detail. `ace-grill` adds terms. `ace-explain` proposes them. A skill that pushes the section past about 40 terms proposes creating `ace/GLOSSARY.md`.

**Default.** No terms. `ace-grill` adds the Glossary section to the root agents file with the first term it settles. With no root agents file, it lists the terms in its summary instead.

## `ace/CODING_STANDARDS.md`

Review and audit jobs read it in full.

| Section | What it holds | Default |
|---|---|---|
| Out of scope | The paths review, audit, and standards jobs skip | The Out of scope list in [templates/CODING_STANDARDS.md](../ace-setup/templates/CODING_STANDARDS.md) |
| Trust boundaries | The parties the project trusts, or that there are none | None. No party is trusted. |
| Rules, tests, and smells | Free content | The rules, tests, and smells in that template |

## `ace/checks/`

Optional. One file per custom check, such as `ace/checks/ACCESSIBILITY.md`, for an area the project wants checked with its own severity. Single rules belong in `ace/CODING_STANDARDS.md`. `ace-review` runs each file as its own check through its [CUSTOM.md](../ace-review/CUSTOM.md), and `ace-audit` as its own domain through its [CUSTOM.md](../ace-audit/CUSTOM.md). The check's name is the file name in lower case, without `.md`. Pick a name no built-in check or audit domain uses, such as `security` or `code`.

| Section | What it holds | Default |
|---|---|---|
| Find | What counts as a finding | Required |
| Drop | What to leave out even when found | Required |
| Severity | What makes a finding Critical, High, Medium, or Low | Required |
| Before scanning | What to read first | Nothing |
| Belongs elsewhere | What another check owns | Coding standards go to Standards, and logic, security, performance, and architecture go to Code. |
| Bar | Which findings an audit files | Only Critical and High |
| Ticket | How an audit ticket looks | Title starts with the check's name, type `Chore` |

**Default.** No folder, no custom checks. Only the root has one, also in a monorepo. `ace-setup` ships [templates/CHECK.md](../ace-setup/templates/CHECK.md) to copy.

## `ace/VERIFY.md`

| Section | What it holds | Used by | Default |
|---|---|---|---|
| Checks | The commands that must pass: lint, typecheck, tests, build | `ace-verify`, `ace-implement`, `ace-review` | The commands the CI workflow runs. Add a lint, typecheck, test, or build script from `package.json`, `Makefile`, or the build tool's config when CI does not run that kind. In a workspace, run only the touched packages, with the filter CI uses. When there are none, there are no checks. Say so. |
| Run the app | How to start the app, or that nothing runs | `ace-verify`, which fixes a wrong step | The dev or start script, with the port and setup the README names. None when the project has no app, such as a library. |
| Check behavior | How to try each kind of change | `ace-verify`, which adds missing lines and fixes wrong ones | None. `ace-verify` finds a way with the tools this environment has. |

## `ace/TICKET_TRACKER.md`

| Section | What it holds | Used by |
|---|---|---|
| Ticket references | How a ticket is written in a commit, branch name, or pull request body, such as `#123` or `ENG-123` | `ace-review`, `ace/CODE_HOSTING.md` |
| Read a ticket | How to read a ticket with its comments | `ace-review`, `ace-grill`, `ace-to-ticket`, `ace-explain` |
| Search tickets | How to search tickets by text | `ace-audit`, `ace-explain` |
| Open a ticket | How to open a ticket with title, body, type, and Risk, in the needs-dev state, and where Priority and Size go when the tracker records them | `ace-to-ticket` (its `OPEN_TICKET.md`) |
| Update a ticket | How to change a ticket's title, body, type, and Risk, and Priority and Size when the tracker records them | `ace-to-ticket` |
| Sub-tickets and blocking | How to attach a sub-ticket to a parent and mark a blocker | `ace-to-ticket` |
| Ticket states | How the tracker shows each ticket state: needs-dev, ready, and working | `ace-work-ticket`, the user |
| Find ready tickets | How to list open tickets in the ready state that no open ticket blocks, in the order to work them | `ace-work-ticket` |
| Find working tickets | How to list open tickets in the working state | `ace-work-ticket`, to release claims a dead run left |
| Set a ticket state | How to move a ticket from one state to another, and read its state back | `ace-work-ticket` |
| Comment on a ticket | How to post a comment on a ticket | `ace-work-ticket` |

**Provider.** [github/TICKET_TRACKER.md](github/TICKET_TRACKER.md) when `ticket_tracker` in `ace/config.json` is `github-issues`. It fills every section above.

**Default.** No ticket tracker, also on GitHub, because a ticket opened by mistake is public. Every ticket step is a skip, except "Open a ticket": the skill writes the title, type, Priority, Size, Risk, and body into the reply, says no ticket tracker is set up, and offers `ace-setup tickets`.

The ticket states:

- **needs-dev**: a person must look at the ticket. Every ticket an agent opens starts here, and `ace-work-ticket` moves a ticket here when it stops for a person.
- **ready**: an agent may work the ticket. A person sets it, or the skill that opened the ticket when `who_sets_ready` in `ace/config.json` allows it.
- **working**: `ace-work-ticket` claimed the ticket. It stays until the pull request merges and closes it. When no pull request is open for it after 3 hours, the next `ace-work-ticket` run moves it to needs-dev with a comment that says why.

## `ace/CODE_HOSTING.md`

| Section | What it holds | Used by | Default |
|---|---|---|---|
| Get the diff | How to get the change to review, from a diff, a pull request, a base ref, or the current branch | `ace-verify`, `ace-review`, `ace-explain` | That section of [github/CODE_HOSTING.md](github/CODE_HOSTING.md), without the pull request case, which needs GitHub. |
| Open a pull request | How to branch, commit, push, and open a pull request, and what to hand back | `ace-open-pr` | None. Stop and offer `ace-setup hosting`. |
| Linked tickets | How to find the tickets a pull request closes, using the tracker's ticket references | `ace-review`, `ace-explain` | Skip |
| Find a pull request | How to find the pull request for a number or a branch, with its state, labels, and comments, and how to list the current user's open pull requests | `ace-mode`, `ace-babysit-pr` | There is no pull request. |
| Comment on a pull request | How to post a comment on a pull request, and how to find an earlier comment by a marker and edit it | `ace-explain`, `ace-mode`, `ace-babysit-pr`. The root agents file also points agents here | The comment goes in the reply. |
| Pull request state | The failing and running checks, unresolved review threads, reviews, new comments, and merge state of a pull request, with a verdict: action, waiting, ready, merged, or closed. A review, comment, or thread that a reply marked `<!-- ace-babysit` follows is answered, and waits for a person | `ace-babysit-pr` | None. Stop and offer `ace-setup hosting`. |
| Check logs | How to read the log of a failing check, and how to run it once more | `ace-babysit-pr` | None. Name the failing check and its link, and fix from the checks in `ace/VERIFY.md` run locally. |
| Reply to a review thread | How to reply inside a review thread and resolve it | `ace-babysit-pr` | The reply goes in the report. |

**Provider.** [github/CODE_HOSTING.md](github/CODE_HOSTING.md) when the code is on GitHub. It needs no setting and fills every section above. So the defaults in the table apply only to code on another host with no `ace/CODE_HOSTING.md`.

## `ace/PRODUCT.md`

Optional. Who the product is for and where it is going, so each run of `ace-grill` ranks directions against the same goal.

| Section | What it holds | Used by |
|---|---|---|
| Users | Who the product is for | `ace-grill` |
| Goal | The one outcome "better" means right now | `ace-grill` |
| Non-goals | What the project leaves alone, even when it would help | `ace-grill` |
| Directions | The direction picked for each scope, with the date it was picked | `ace-grill`, which replaces a scope's line after each pick |

**Default.** No file. `ace-grill` asks for Users, Goal, and Non-goals in its anchor round, no direction is picked yet, and it creates the file from [templates/PRODUCT.md](../ace-setup/templates/PRODUCT.md) once the user picks one.

## `ace/config.json`

Settings, not an adapter. An adapter says how this project does a job. A setting says how much agents do on their own, and which optional features are on. [config.schema.json](../ace-setup/config.schema.json) defines each setting, its values, and its default. A skill reads a setting as [SKILL.md](SKILL.md) says, so a missing file or setting is no error.

| Setting | Used by |
|---|---|
| `autonomy` | Every skill that reads `who_sets_ready` or `review.fixes`, for their value when the key is missing |
| `ticket_tracker` | Every skill that reads `ace/TICKET_TRACKER.md`, to pick the provider |
| `who_starts_runs` | `ace-setup`, which writes `ace/CYCLE.md` when it is `custom` |
| `who_sets_ready` | `ace-to-ticket`, `ace-audit`, `ace-work-ticket` |
| `review` | `ace-review` |
| `write_adrs` | `ace-grill` |
| `max_tickets_per_audit_domain` | `ace-audit` |

## `ace/adrs/`

Optional. One file per architecture decision, from `ace-grill` when `write_adrs` is `true`. `ace-explain` reads them for why questions. `ace-implement` marks one `Superseded` when a plan replaces it.

## `ace/CYCLE.md`

Optional. It matters only when something other than a person starts runs, such as a CI job that a label starts or a cloud agent on a schedule. Ace writes no runner config: the user sets up the runner, and this file tells agents what it does.

| Section | What it holds | Used by |
|---|---|---|
| After Plan, After Build, After Review, After Audit | What the runner needs when that `ace-mode` playbook ends, such as setting a label or moving a ticket | `ace-mode` |
| Runs | Each trigger that starts an agent run without a person, and the message that run gets, or `None.` | `ace-mode`, the user |

**Default.** A person starts every run, and `ace-mode` names the next step from its Continue table.
