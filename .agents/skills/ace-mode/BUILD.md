# Perf, Fix, Refactor, Garden, and Build

The playbooks that change code.

For a small, clear `S` fix or edit (one to a few files, obvious cause and shape), edit directly, check against `ace/CODING_STANDARDS.md`, run the checks in `ace/VERIFY.md`, and finish, skipping `ace-diagnose`, `ace-implement`, and `STANDARDS.md`.

## Perf

1. Measure it the way the user hits it, three runs or more. Write down the command, each number, and the spread. When it is not slow, report the numbers and stop.
2. Find what the time goes to, with a profiler or a timer around each step, and trace it to its source.
3. `ace-implement`, with the fix for that source as the plan. Behavior stays the same.
4. Measure again the same way. When the gain is inside the spread, revert the fix and stop. Report the numbers before and after, with the command.
5. Finish the change.

## Fix

1. Skip `ace-diagnose` when the root cause is clear from the report, error, or code. Otherwise run `ace-diagnose`; if no loop goes red, report what it tried and stop.
2. `ace-implement`, with the cause or diagnosis as the plan. Write a failing regression test first at the diagnosed or public seam; skip only with no seam, and say why.
3. Finish the change.

## Refactor

1. When the message names a ticket, read it with its comments per `ace/TICKET_TRACKER.md`. When it names a file in `ace/temporary-plans/`, read it as the plan.
2. `ace-implement`, with the refactor as the plan. Behavior stays the same.
3. Finish the change.

## Garden

1. `ace-garden` with the topic and scope the message names. When it fixed nothing, reply with its report and stop.
2. Finish the change.

## Build

1. When the message names a ticket, read it with its comments per `ace/TICKET_TRACKER.md`. When it names a file in `ace/temporary-plans/`, read it as the plan.
2. Run `ace-grill` only on open material decisions (behavior, UX, data shape, or public contracts); for low-stakes reversible details, state defaults in one line and proceed. Keep a named ticket as one ticket.
3. `ace-implement`.
4. Finish the change.

## Finish a change

Perf, Fix, Refactor, Garden, and Build end here:

1. Run `ace-open-pr` if the user asked to ship or open a pull request.
2. Run `ace-review` if the user asked to review it, subject to its `require_other_model` rule.

Leave unasked follow-ups to the single closing hand-off line.
