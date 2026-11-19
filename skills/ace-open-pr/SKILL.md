---
name: ace-open-pr
description: Opens a pull request for the current work on GitHub.
disable-model-invocation: true
---

# Open pull request

Open a pull request for the current work. Done means the pull request exists, its body names the ticket it closes when the work implements one, holds each verify file change `ace-verify` proposed for this work that the tree lacks, and its URL is handed back.

## Constraints

- Open the pull request only as the "Open a pull request" section of [OPEN.md](../ace-mode/shared/adapters/github/pull-requests/OPEN.md) says. That section is the only way to open it.
- When this work implements a ticket, name it in the body as the ticket the pull request closes, in the form the "Ticket references" section of `ace/TICKET_TRACKER.md` gives, such as `Closes #42`. The review finds the ticket by it, and the merge closes it.
- When the `ace-verify` report of this work proposes verify file changes that the working tree does not hold yet, put them into the pull request body: in the section on how the change was verified, or else in a last section `Proposed verify file changes`. Copy each proposed line with its file path, and say that the lines are not in this pull request and a person adds them.
- The ticket and the verify file changes go into the body also when the section says to describe only what changed or to fill exactly the template's sections. Put each into the template section that fits, such as one for linked issues or testing; add a section only when none fits.

## Workflow

1. Follow that section.
2. Hand back what it says to hand back.
