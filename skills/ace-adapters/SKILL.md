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
| `ace/CYCLE.md` | [github/CYCLE.md](github/CYCLE.md), when `who_starts_runs` is `github-actions` |

A provider ships with Ace and holds no project values, so the project never copies or updates it. The project writes its own file in `ace/` only for a tool Ace has no provider for, such as Linear or GitLab, or to change one section of a provider.

## Find a section

Take the first of these that has the section. Find a section by its job. Its heading may differ from the one a skill names.

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

## Runs with nobody to answer

`ace-work-ticket` and every run a schedule or a label starts need a ticket tracker for each ticket step: a provider or an `ace/TICKET_TRACKER.md`. A default that writes a ticket, a pull request, or a comment into the reply is a stop in such a run, since nobody reads the reply. Every other default works there too.

## Writing adapters

Only `ace-setup` creates an adapter file, with one exception: `ace-verify` creates a missing `ace/VERIFY.md` from what it found and tried, as its step 5 says. Every other skill leaves a missing adapter missing and uses the provider or the default.
