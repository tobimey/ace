# Adapter contract

The adapters in `ace/` belong to the project. Change them freely. Ace skills depend only on the sections below. Each section must exist and do the job named here. Its heading may differ, since skills find a section by its job. Everything else in an adapter is free.

When a skill misses a section, it names the section and says what it must hold. A skill that edits files offers to add it. A read-only skill stops, or skips that source and says so.

## `ace/GLOSSARY.md`

Free form. Skills read it for the project's terms, and `ace-grill` adds terms to it.

## `ace/CODING_STANDARDS.md`

Review and audit jobs read it in full. It must state:

- **Out of scope**: the paths review, audit, and standards jobs skip.
- **Trust boundaries**: the parties the project trusts, or that there are none.
- **Packages** (monorepo only): the package files that add to this one, by path.

Rules, tests, and smells are free content.

## `ace/VERIFY.md`

| Section | What it holds | Used by |
|---|---|---|
| Checks | The commands that must pass: lint, typecheck, tests, build | `ace-verify`, `ace-implement`, `ace-review`, `ace-validate-standards` |
| Run the app | How to start the app, or that nothing runs | `ace-verify` |
| Check behavior | How to try each kind of change | `ace-verify` |
| Packages (monorepo only) | The package verify files, by path | the same skills as Checks |

## `ace/TICKET_TRACKER.md`

| Section | What it holds | Used by |
|---|---|---|
| Ticket references | How a ticket is written in a commit, branch name, or pull request body, such as `#123` or `ENG-123` | `ace-check-spec`, `ace/CODE_HOSTING.md` |
| Read a ticket | How to read a ticket with its comments | `ace-check-spec`, `ace-to-ticket`, `ace-why` |
| Search tickets | How to search tickets by text | `ace-audit`, `ace-why` |
| Open a ticket | How to open a ticket with title, body, type, Priority, Size, and Risk | `ace-open-ticket` |
| Update a ticket | How to change a ticket's title, body, type, Priority, Size, and Risk | `ace-to-ticket` |
| Sub-tickets and blocking | How to attach a sub-ticket to a parent and mark a blocker | `ace-to-ticket` |

## `ace/CODE_HOSTING.md`

| Section | What it holds | Used by |
|---|---|---|
| Get the diff | How to get the change to review, from a diff, a pull request, a base ref, or the current branch | `ace-verify`, `ace-review`, `ace-check-spec`, `ace-validate-standards`, `ace-explain-change` |
| Open a pull request | How to branch, commit, push, and open a pull request, and what to hand back | `ace-open-pr` |
| Linked tickets | How to find the tickets a pull request closes, using the tracker's ticket references | `ace-check-spec`, `ace-why` |
| Find a pull request | How to find the pull request for a number or a branch, with its state, labels, and comments | `ace-mode` |
| Comment on a pull request | How to post a comment on a pull request, and how to find an earlier comment by a marker and edit it | `ace-explain-change`, `ace-mode`. The root agents file also points agents here |

## `ace/CYCLE.md`

How work moves between stages, and what starts a run. Ace skills say what comes next. This file says how it happens in this project: a person types it, a label starts a workflow, or a schedule runs an agent.

| Section | What it holds | Used by |
|---|---|---|
| After Plan, After Build, After Review, After Audit | What to do when that `ace-mode` playbook ends: tell the user the next step, set a label, move a ticket, or nothing | `ace-mode` |
| Runs | Each trigger that starts an agent run without a person, and the message that run gets, or `None.` | `ace-mode`, the user |

A missing hand-off section is no error. `ace-mode` then names the next step to the user.
