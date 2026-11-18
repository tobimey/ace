---
name: ace-adapters
description: Says how an Ace skill finds a project fact in the adapters in `ace/`, in a built-in provider such as GitHub Issues, or in a default, and how it reads a setting from `ace/config.json`. ace-mode and the root agents file load it.
disable-model-invocation: true
---

# Adapters

An Ace skill that needs a project fact, such as the check commands or how to open a pull request, reads it from an adapter. Ace works without an `ace` folder. Every section has a default, so a project needs no setup before the first task.

## The adapters

A skill names an adapter by its path in `ace/`. That name means the adapter, not only the file:

| Adapter | Sections and defaults | Built-in provider, used when |
|---|---|---|
| `ace/VERIFY.md` | [contract/VERIFY.md](contract/VERIFY.md) | None |
| `ace/CODING_STANDARDS.md` | [contract/CODING_STANDARDS.md](contract/CODING_STANDARDS.md) | None |
| `ace/TICKET_TRACKER.md` | [contract/TICKET_TRACKER.md](contract/TICKET_TRACKER.md) | [github/TICKET_TRACKER.md](github/TICKET_TRACKER.md), when `ticket_tracker` is `github-issues` |
| `ace/CODE_HOSTING.md` | [contract/CODE_HOSTING.md](contract/CODE_HOSTING.md) | [github/CODE_HOSTING.md](github/CODE_HOSTING.md), when the code is on GitHub |
| `ace/CYCLE.md` | [contract/CYCLE.md](contract/CYCLE.md) | None |
| `ace/PRODUCT.md` | [contract/PRODUCT.md](contract/PRODUCT.md) | None |

The glossary and `ace/checks/` have their own contract files in [contract/](contract/). Read only the contract file of the adapter you need.

A provider ships with Ace and holds no project values, so the project never copies or updates it. The project writes its own file in `ace/` only for a tool Ace has no provider for, such as Linear or GitLab, or to change one section of a provider.

## Find a section

Take the first of these that has the section. Find a section by its job. Its heading may differ from the one a skill names. In step 1, the root file and the package files add up, so a section found in any of them counts.

1. The file in `ace/`, and the same file in each package `ace` folder that covers the touched paths, as [contract/PACKAGES.md](contract/PACKAGES.md) says.
2. The adapter's built-in provider, when the table above selects it.
3. The default in the adapter's contract file.

A default of "skip" skips that step. Name the skipped step in the reply.

Stop only when the default does not fit this project, such as a pull request when the code is not on GitHub. Name the section, say what it must hold, and offer the `ace-setup` module that sets it up, such as `ace-setup tickets`.

## Read a setting

Settings live in `ace/config.json`. [config.schema.json](../ace-setup/config.schema.json) defines each one. Read a setting in this order:

1. The key, when the file has it.
2. For `who_sets_ready` and `review.fixes`, the value `autonomy` sets:

   | `autonomy` | `who_sets_ready` | `review.fixes` |
   |---|---|---|
   | `low` | `person` | `none` |
   | `medium` | `person` | `simple-only` |
   | `high` | `planning-agents` | `all` |

   A missing `autonomy` is `medium`.
3. The default the schema names.

## Say which defaults ran

Name each default you used once in the reply, in one line, such as `No ace/VERIFY.md: ran the checks from .github/workflows/ci.yml.` Skip the line when every section came from an adapter file or a provider.

## Sign what you post

Before you write anything to a ticket tracker or a code host, read [SIGN.md](SIGN.md) and start the text with the model line it gives.

## Runs with nobody to answer

In a run nobody watches, such as `ace-work-ticket` or a run a schedule or a label starts, a default that writes a ticket, a pull request, or a comment into the reply is a stop.

## Writing adapters

Only `ace-setup` writes adapter files, except where a skill says it may, as `ace-grill` does for `ace/PRODUCT.md` and `ace-verify` does for `ace/VERIFY.md` when the user says yes. Every other skill leaves a missing adapter missing.
