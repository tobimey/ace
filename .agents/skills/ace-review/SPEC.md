# Spec check

Does the change do what its linked ticket asked.

## Find the linked ticket

If the caller named a ticket, use that. When the caller passed a pull request, find its linked tickets as the "Linked tickets" section of [PULL_REQUESTS.md](../ace-adapters/github/PULL_REQUESTS.md) says. Otherwise search the branch name and `git log` for a ticket reference, in the form the "Ticket references" section of `ace/TICKET_TRACKER.md` names. Read each candidate with its comments as `ace/TICKET_TRACKER.md` says. A reference to the pull request itself does not count. Use the first real ticket.

When none of those sources names a ticket, the result is `No linked ticket. Spec check skipped.` A missing ticket is not a failure.

## Find

Compare the diff with the ticket and its comments. Each of these is a finding:

- A requirement in the ticket is missing or only partly done.
- A requirement is present, and the implementation does the wrong thing. Quote the ticket line.
- The diff does something the ticket did not ask for.

## Belongs elsewhere

Judge spec match only. Logic bugs, security holes, performance costs, and architecture belong to [Code](CODE.md). Coding standards belong to [Standards](STANDARDS.md).

## Severity

- A missing, partial, or wrong requirement is `blocker`.
- Work the ticket did not ask for is `should-fix`.

## Fix type

Every spec finding is `needs-a-person`. Closing the gap means more implementing or a person's call on the scope, not a review fix.

## Result

One line for the report:

- `Spec matches.` when there is no spec finding.
- `No linked ticket. Spec check skipped.`
- `Spec diverges from TICKET.`, with the ticket reference, when there are spec findings. The findings follow in the report.
