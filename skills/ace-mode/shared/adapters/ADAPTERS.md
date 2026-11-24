# Adapters

An Ace skill reads each project fact, such as the check commands or how to open a ticket, from an adapter. Every section has a default, so a project needs no `ace` folder before the first task.

## The adapters

A skill names an adapter by its path in `ace/`. That name means the adapter, not only the file:

| Adapter | Sections and defaults | Built-in provider, used when |
|---|---|---|
| `ace/VERIFY.md` | [contract/VERIFY.md](contract/VERIFY.md) | None |
| `ace/CODING_STANDARDS.md` | [contract/CODING_STANDARDS.md](contract/CODING_STANDARDS.md) | None |
| `ace/TICKET_TRACKER.md` | [contract/TICKET_TRACKER.md](contract/TICKET_TRACKER.md) | [github/TICKET_TRACKER.md](github/TICKET_TRACKER.md), when `ticket_tracker` is `github-issues` |
| `ace/CYCLE.md` | [contract/CYCLE.md](contract/CYCLE.md) | None |
| `ace/PRODUCT.md` | [contract/PRODUCT.md](contract/PRODUCT.md) | None |

The glossary and `ace/checks/` have their own contract files in [contract/](contract/). Read only the contract file of the adapter you need.

Pull requests have no adapter. Ace supports them only on GitHub, as [github/PULL_REQUESTS.md](github/PULL_REQUESTS.md) says.

## Find a section

Take the first of these that has the section. Find a section by its job. Its heading may differ from the one a skill names. In step 1, the root file and the package files add up, so a section found in any of them counts.

1. The file in `ace/`, and the same file in each package `ace` folder that covers the touched paths, as [contract/PACKAGES.md](contract/PACKAGES.md) says.
2. The adapter's built-in provider, when the table above selects it.
3. The default in the adapter's contract file.

A default of "skip" skips that step. Name the skipped step in the reply.

Stop only when the default does not fit this project. Name the section, say what it must hold, and offer the `ace-setup` module that sets it up, such as `ace-setup tickets`.

## Read a setting

Read a setting from `ace/config.json`. A missing file or key uses the default the reading skill names, else the one in [config.schema.json](../../../ace-setup/config.schema.json). A missing `autonomy` is `medium`.

## Say which defaults ran

Name each default you used once in the reply, in one line, such as `No ace/VERIFY.md: ran the checks from .github/workflows/ci.yml.` Skip the line when every section came from an adapter file or a provider.

## Sign what you post

Start every text written to a ticket tracker or code host (pull request, comment, review reply, ticket, or reply fallback) with `Model: <model id>`, such as `Model: claude-sonnet-4-6`. Place any HTML marker (such as `<!-- ace-review -->`) on line 1 and the model line on line 2. Refresh the line with your own model when editing a comment. Take the id from `ACE_MODEL` when set, else from your harness metadata; when neither gives an id, write `Model: unknown`.

## Runs with nobody to answer

In a run nobody watches, such as `ace-work-ticket` or a run a schedule or a label starts, a default that writes a ticket, a pull request, or a comment into the reply is a stop.

When the message names a runner, such as `Runner: cursor-cloud.`, follow its section in `ace/CYCLE.md` for the whole run, or stop when it has none. Its Target says which pull request or ticket the message means. Each section it holds, such as "Comment on a pull request", replaces the one with that job in an adapter, a provider, or [PULL_REQUESTS.md](github/PULL_REQUESTS.md). When that fails, retry or stop instead of falling back, since the replaced way may post as the wrong account.

## Writing adapters

Only `ace-setup` writes adapter files, unless a skill says it may. Leave a missing adapter missing.
