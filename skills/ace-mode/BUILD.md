# Fix, Refactor, Garden, and Build

The playbooks that change code.

## Fix

1. Skip `ace-diagnose` when the root cause is clear from the report, error, or code. Otherwise run `ace-diagnose`; if no loop goes red, report what it tried and stop.
2. `ace-implement`, with the cause or diagnosis as the plan. Write a failing regression test first at the diagnosed or public seam; skip only with no seam, and say why.
3. Finish the change.

## Refactor

1. When the message names a ticket, read it with its comments per `ace/TICKET_TRACKER.md`.
2. `ace-implement`, with the refactor as the plan. Behavior stays the same.
3. Finish the change.

## Garden

1. `ace-garden` with the topic and scope the message names. When it fixed nothing, reply with its report and stop.
2. Finish the change.

## Build

1. When the message names a ticket, read it with its comments per `ace/TICKET_TRACKER.md`.
2. Run `ace-grill` only on open material decisions (behavior, UX, data shape, or public contracts); for low-stakes reversible details, state defaults in one line and proceed. Keep a named ticket as one ticket.
3. `ace-implement`.
4. Finish the change.

## Finish a change

Perf, Fix, Refactor, Garden, and Build end here:

1. Run `ace-open-pr` if the user asked to ship or open a pull request.
2. Run `ace-review` if the user asked to review it, subject to its `require_other_model` rule.

Leave unasked follow-ups to the single closing line in [CONTINUE.md](CONTINUE.md).
