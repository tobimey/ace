# Adapter contract

The adapters in `ace/`, and the glossary in the root agents file, belong to the project. Change them freely. Ace skills depend only on the sections below. Each section does the job named here. Its heading may differ, since skills find a section by its job. Everything else in an adapter is free.

Every section has a default. A skill uses it when the file or the section is missing, as [SKILL.md](SKILL.md) says. `ace-setup` writes an adapter to replace the defaults with what this project does.

**GitHub** in a default means `git remote get-url origin` points at github.com and `gh auth status` succeeds. A default that needs GitHub does not fit any other project.

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
| Packages (monorepo only) | The package files that add to this one, by path | None |

## `ace/VERIFY.md`

| Section | What it holds | Used by | Default |
|---|---|---|---|
| Checks | The commands that must pass: lint, typecheck, tests, build | `ace-verify`, `ace-implement`, `ace-review`, `ace-validate-standards` | The commands the CI workflow runs. Add a lint, typecheck, test, or build script from `package.json`, `Makefile`, or the build tool's config when CI does not run that kind. In a workspace, run only the touched packages, with the filter CI uses. When there are none, there are no checks. Say so. |
| Run the app | How to start the app, or that nothing runs | `ace-verify`, which fixes a wrong step | The dev or start script, with the port and setup the README names. None when the project has no app, such as a library. |
| Check behavior | How to try each kind of change | `ace-verify`, which adds missing lines and fixes wrong ones | None. `ace-verify` finds a way with the tools this environment has. |
| Packages (monorepo only) | The package verify files, by path | the same skills as Checks | None |

## `ace/TICKET_TRACKER.md`

| Section | What it holds | Used by |
|---|---|---|
| Ticket references | How a ticket is written in a commit, branch name, or pull request body, such as `#123` or `ENG-123` | `ace-check-spec`, `ace/CODE_HOSTING.md` |
| Read a ticket | How to read a ticket with its comments | `ace-check-spec`, `ace-grill`, `ace-to-ticket`, `ace-explain` |
| Search tickets | How to search tickets by text | `ace-audit`, `ace-explain` |
| Open a ticket | How to open a ticket with title, body, type, and Risk, in the needs-dev state, and where Priority and Size go when the tracker records them | `ace-open-ticket` |
| Update a ticket | How to change a ticket's title, body, type, and Risk, and Priority and Size when the tracker records them | `ace-to-ticket` |
| Sub-tickets and blocking | How to attach a sub-ticket to a parent and mark a blocker | `ace-to-ticket` |
| Ticket states | How the tracker shows each ticket state: needs-dev, ready, and working | `ace-work-ticket`, the user |
| Find ready tickets | How to list open tickets in the ready state that no open ticket blocks, in the order to work them | `ace-work-ticket` |
| Set a ticket state | How to move a ticket from one state to another, and read its state back | `ace-work-ticket` |
| Comment on a ticket | How to post a comment on a ticket | `ace-work-ticket` |

**Default.** No ticket tracker, also on GitHub, because a ticket opened by mistake is public. Every ticket step is a skip, except "Open a ticket": the skill writes the title, type, Priority, Size, Risk, and body into the reply, says no ticket tracker is set up, and offers `ace-setup tickets`.

The ticket states:

- **needs-dev**: a person must look at the ticket. Every ticket an agent opens starts here, and `ace-work-ticket` moves a ticket here when it stops for a person.
- **ready**: an agent may work the ticket. A person sets it, or the skill that opened the ticket when `who_sets_ready` in `ace/config.json` allows it.
- **working**: `ace-work-ticket` claimed the ticket. It stays until the pull request merges and closes it.

## `ace/CODE_HOSTING.md`

| Section | What it holds | Used by | Default |
|---|---|---|---|
| Get the diff | How to get the change to review, from a diff, a pull request, a base ref, or the current branch | `ace-verify`, `ace-review`, `ace-check-spec`, `ace-validate-standards`, `ace-explain-change` | That section of [templates/CODE_HOSTING.md](../ace-setup/templates/CODE_HOSTING.md), with the default branch from `git symbolic-ref --short refs/remotes/origin/HEAD`, else `main`, else `master`. A pull request needs GitHub. |
| Open a pull request | How to branch, commit, push, and open a pull request, and what to hand back | `ace-open-pr` | On GitHub, that section of the template. `<REPO>` is `gh repo view --json nameWithOwner --jq .nameWithOwner`. The body fills the pull request template under `.github/`, or, with none, has the sections What changed and How it was verified. |
| Linked tickets | How to find the tickets a pull request closes, using the tracker's ticket references | `ace-check-spec`, `ace-explain` | Skip |
| Find a pull request | How to find the pull request for a number or a branch, with its state, labels, and comments | `ace-mode` | On GitHub, that section of the template. Otherwise there is no pull request. |
| Comment on a pull request | How to post a comment on a pull request, and how to find an earlier comment by a marker and edit it | `ace-explain-change`, `ace-mode`. The root agents file also points agents here | On GitHub, that section of the template. Otherwise the comment goes in the reply. |

## `ace/config.json`

Settings, not an adapter. An adapter says how this project does a job. A setting says how much agents do on their own, and which optional features are on. [config.schema.json](../ace-setup/config.schema.json) defines each setting, its values, and its default. Each skill that reads a setting names its default, so a missing file or setting is no error.

| Setting | Used by |
|---|---|
| `who_sets_ready` | `ace-to-ticket`, `ace-audit`, `ace-work-ticket` |
| `review_fixes` | `ace-review`, `ace-validate-standards` |
| `write_adrs` | `ace-grill` |
| `max_tickets_per_audit_domain` | `ace-audit` |

## `ace/adrs/`

Optional. One file per architecture decision, from `ace-grill` when `write_adrs` is `true`. `ace-explain` reads them for why questions. `ace-implement` marks one `Superseded` when a plan replaces it.

## `ace/CYCLE.md`

Optional. It exists only when something other than a person starts runs, such as a label that starts a workflow or a schedule that runs an agent.

| Section | What it holds | Used by |
|---|---|---|
| After Plan, After Build, After Review, After Audit | What the runner needs when that `ace-mode` playbook ends, such as setting a label or moving a ticket | `ace-mode` |
| Runs | Each trigger that starts an agent run without a person, and the message that run gets, or `None.` | `ace-mode`, the user |

**Default.** A person starts every run, and `ace-mode` names the next step from its Continue table.
