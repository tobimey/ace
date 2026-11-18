---
name: ace-adapters
description: Says how an Ace skill finds a project fact in the adapters in `ace/`, in a built-in provider such as GitHub Issues, or in a default, and how it reads a setting from `ace/config.json`. ace-mode and the root agents file load it.
disable-model-invocation: true
---

# Adapters

An Ace skill that needs a project fact, such as the check commands or how to open a pull request, reads it from an adapter. Ace works without an `ace` folder. Every section has a default, so a project needs no setup before the first task.

## The adapters

A skill names an adapter by its path in `ace/`. That name means the adapter, not only the file:

| Adapter | Built-in provider, used when |
|---|---|
| `ace/VERIFY.md` | None |
| `ace/CODING_STANDARDS.md` | None |
| `ace/TICKET_TRACKER.md` | [github/TICKET_TRACKER.md](github/TICKET_TRACKER.md), when `ticket_tracker` is `github-issues` |
| `ace/CODE_HOSTING.md` | [github/CODE_HOSTING.md](github/CODE_HOSTING.md), when the code is on GitHub, as [ADAPTERS.md](ADAPTERS.md) defines it |
| `ace/CYCLE.md` | None |
| `ace/PRODUCT.md` | None |

A provider ships with Ace and holds no project values, so the project never copies or updates it. The project writes its own file in `ace/` only for a tool Ace has no provider for, such as Linear or GitLab, or to change one section of a provider.

## Find a section

Take the first of these that has the section. Find a section by its job. Its heading may differ from the one a skill names. In step 1, the root file and the package files add up, as "Package folders" says, so a section found in any of them counts.

1. The file in `ace/`, and the same file in each package `ace` folder that covers the touched paths, as "Package folders" in [ADAPTERS.md](ADAPTERS.md) says.
2. The adapter's built-in provider, when the table above selects it.
3. The default in [ADAPTERS.md](ADAPTERS.md).

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

Everything you write to a ticket tracker or a code host starts with one line that names the model that wrote it: `Model: <model id>`, such as `Model: claude-opus-5-5`. That covers a pull request body, a pull request comment, a reply in a review thread, an inline comment, a ticket body, and a ticket comment. It holds for every adapter, also a project's own file in `ace/`.

- When the text carries a marker such as `<!-- ace-review -->`, the marker comes first and the model line second, so the model line is the first visible line.
- When you edit an earlier comment, write the line again with your own model.
- Take the model id from the `ACE_MODEL` environment variable when it is set. Otherwise use the id your harness gives you, or its name for the model when it gives no id.
- When a default puts the text into the reply instead, such as a comment with no code host, the reply holds the model line too.

## Runs with nobody to answer

`ace-work-ticket` and every run a schedule or a label starts need a ticket tracker for each ticket step: a provider or an `ace/TICKET_TRACKER.md`. A default that writes a ticket, a pull request, or a comment into the reply is a stop in such a run, since nobody reads the reply. Every other default works there too. Such a run reads and posts through the code host's CLI, such as `gh` for GitHub, logged in where the agent runs.

## Writing adapters

Only `ace-setup` creates an adapter file, with two exceptions: `ace-verify` creates a missing `ace/VERIFY.md` from what it found and tried, as its step 5 says, and `ace-grill` creates a missing `ace/PRODUCT.md` once the user picks a direction, as step 6 of its `DIRECTION.md` says. Every other skill leaves a missing adapter missing and uses the provider or the default.
