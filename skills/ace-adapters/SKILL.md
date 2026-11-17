---
name: ace-adapters
description: Says how an Ace skill finds a project fact in the adapters in `ace/`, and what it uses when a file or section is missing. ace-mode and the root agents file load it.
disable-model-invocation: true
---

# Adapters

An Ace skill that needs a project fact, such as the check commands or how to open a pull request, reads it from an adapter in `ace/`. Ace works without that folder. Every section has a default, so a project needs no setup before the first task.

## Find a section

1. Read the section in its adapter in `ace/`, and in each package adapter its "Packages" section lists for the touched paths. Find the section by its job. Its heading may differ from the one a skill names.
2. When the file or the section is missing, use its default from [ADAPTERS.md](ADAPTERS.md).
3. A default of "skip" skips that step. Name the skipped step in the reply.
4. Stop only when the default does not fit this project, such as a pull request when the code is not on GitHub. Name the section, say what it must hold, and offer the `ace-setup` module that writes it, such as `ace-setup tickets`.

An adapter section that exists always wins over its default.

## Say which defaults ran

Name each default you used once in the reply, in one line, such as `No ace/VERIFY.md: ran the checks from .github/workflows/ci.yml.` Skip the line when every section came from an adapter.

## Runs with nobody to answer

`ace-work-ticket` and every run a schedule or a label starts need `ace/TICKET_TRACKER.md` for each ticket step. A default that writes a ticket, a pull request, or a comment into the reply is a stop in such a run, since nobody reads the reply. Every other default works there too.

## Writing adapters

Only `ace-setup` creates an adapter, with one exception: `ace-verify` creates a missing `ace/VERIFY.md` from what it found and tried, as its step 5 says. Every other skill leaves a missing adapter missing and uses the default.
