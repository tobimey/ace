---
name: ace-check-spec
description: Checks whether the current change does what the linked ticket asked.
disable-model-invocation: true
---

# Spec

Check whether this change does what the linked ticket asked. Done means pass, skip, or fail is written.

## Constraints

- Read only. Leave the repository, its commits, and the pull request as they are.
- Judge spec match only. Logic bugs, security holes, and performance costs belong to `ace-review`. Coding standards belong to `ace-validate-standards`.
- A missing ticket is not a failure. Write `No linked ticket. Spec check skipped.`

## Workflow

```
- [ ] 1. Get the diff
- [ ] 2. Find the linked ticket
- [ ] 3. Pass, skip, or fail
```

## 1. Get the diff

Get the diff as the "Get the diff" section of `ace/CODE_HOSTING.md` says. If that file or that section is missing, stop and say which one is missing.

Stop if there is no diff.

Read the diff. Fetch only the diff, leaving out `--json commits`.

## 2. Find the linked ticket

If the caller named a ticket, use that. When the caller passed a pull request, find its linked tickets as `ace/CODE_HOSTING.md` says. Then search `git log` or the commit list for a ticket reference such as `Closes #N`, `Fixes #N`, or a bare `#N`. Read each candidate as `ace/TICKET_TRACKER.md` says. A number that is the pull request itself does not count. Use the first real ticket.

Skip when none of those sources names a ticket.

## 3. Pass, skip, or fail

No linked ticket: write `No linked ticket. Spec check skipped.`

A linked ticket fails when any of these are true:

- A requirement in the ticket is missing or only partly done.
- The diff does something the ticket did not ask for.
- A requirement is present, and the implementation does the wrong thing. Quote the ticket line.

On a failure, write how the diff diverges from the ticket.

Otherwise the spec passes. Write `Spec matches.`
