# Adapter contract

The adapters in `ace/`, and the glossary in the root agents file, belong to the project. Change them freely. Ace skills depend only on the sections below. Each section must exist and do the job named here. Its heading may differ, since skills find a section by its job. Everything else in an adapter is free.

When a skill misses a section, it names the section and says what it must hold. A skill that edits files offers to add it. Any other skill stops, unless it says what to do instead. The Ace section of the root agents file holds this rule. Running `ace-setup` again adds every missing section.

## Glossary

The project's terms, in two tiers. Only the root has a glossary, also in a monorepo.

- **Glossary section of the root agents file.** Harnesses load that file into every session, so every agent has the terms without looking them up. It holds one line per term: `- **term**: what it means here. Not: other words for it.` It leaves out words a senior engineer already knows. A term's one-line definition lives only here.
- **`ace/GLOSSARY.md`, optional.** It is free form and holds what does not fit on one line: how terms relate, examples, open questions, a section per bounded context. It exists once the section passes about 40 terms, or once one word means different things in different parts of the project. The section then keeps every one-line entry and adds a line that points at this file.

Skills use the terms from the root agents file, and read `ace/GLOSSARY.md` when it exists and they need the detail. `ace-grill` adds terms. `ace-explain` proposes them. A skill that pushes the section past about 40 terms proposes creating `ace/GLOSSARY.md`.

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
| Run the app | How to start the app, or that nothing runs | `ace-verify`, which fixes a wrong step |
| Check behavior | How to try each kind of change | `ace-verify`, which adds missing lines and fixes wrong ones |
| Packages (monorepo only) | The package verify files, by path | the same skills as Checks |

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

The ticket states:

- **needs-dev**: a person must look at the ticket. Every ticket an agent opens starts here, and `ace-work-ticket` moves a ticket here when it stops for a person.
- **ready**: an agent may work the ticket. Only a person sets it.
- **working**: `ace-work-ticket` claimed the ticket. It stays until the pull request merges and closes it.

## `ace/CODE_HOSTING.md`

| Section | What it holds | Used by |
|---|---|---|
| Get the diff | How to get the change to review, from a diff, a pull request, a base ref, or the current branch | `ace-verify`, `ace-review`, `ace-check-spec`, `ace-validate-standards`, `ace-explain-change` |
| Open a pull request | How to branch, commit, push, and open a pull request, and what to hand back | `ace-open-pr` |
| Linked tickets | How to find the tickets a pull request closes, using the tracker's ticket references | `ace-check-spec`, `ace-explain` |
| Find a pull request | How to find the pull request for a number or a branch, with its state, labels, and comments | `ace-mode` |
| Comment on a pull request | How to post a comment on a pull request, and how to find an earlier comment by a marker and edit it | `ace-explain-change`, `ace-mode`. The root agents file also points agents here |

## `ace/CYCLE.md`

Optional. It exists only when something other than a person starts runs, such as a label that starts a workflow or a schedule that runs an agent. Without it, a person starts every run, and `ace-mode` names the next step from its Continue table.

| Section | What it holds | Used by |
|---|---|---|
| After Plan, After Build, After Review, After Audit | What the runner needs when that `ace-mode` playbook ends, such as setting a label or moving a ticket | `ace-mode` |
| Runs | Each trigger that starts an agent run without a person, and the message that run gets, or `None.` | `ace-mode`, the user |

A missing file or hand-off section is no error. `ace-mode` then names the next step to the user.
