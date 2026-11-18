# Fix, Refactor, and Build

The playbooks that change code. `ace-mode` routes here, and its constraints apply.

## Fix

1. `ace-diagnose`. When no loop goes red on the bug, report what it tried and stop.
2. `ace-implement`, with the diagnosis as the plan. The first test reproduces the bug at the seam the diagnosis names. When it names no seam, skip that test and say why.
3. Finish the change.

## Refactor

1. When the message names a ticket, read it with its comments as `ace/TICKET_TRACKER.md` says.
2. `ace-implement`, with the refactor as the plan. Behavior stays the same.
3. Finish the change.

## Build

1. When the message names a ticket, read it with its comments as `ace/TICKET_TRACKER.md` says.
2. When the plan leaves a decision open, `ace-grill` on the open decisions only. When a ticket is named, tell grill to keep it as one ticket, so its body stays the spec for what you build.
3. `ace-implement`.
4. Finish the change.

## Finish a change

Perf, Fix, Refactor, and Build end with these steps, in place of "Finish the change".

1. `ace-open-pr` when the user asked to ship or open a pull request. Otherwise offer it.
2. Offer the review, best on another model. `ace-review` says whether it may run here. `ace-implement` already checked the coding standards.
