# Spec check

Does the change do what its linked ticket or plan asked.

## Find the linked ticket or plan

If the caller named a ticket or plan, use that. When the caller passed a pull request, find its linked tickets as the "Linked tickets" section of [PULL_REQUESTS.md](../ace-mode/shared/adapters/github/PULL_REQUESTS.md) says. Otherwise search the branch name and `git log` for a ticket reference, in the form the "Ticket references" section of `ace/TICKET_TRACKER.md` names. Read each candidate with its comments as `ace/TICKET_TRACKER.md` says. A reference to the pull request itself does not count. Use the first real ticket. With no ticket, use the `Plan` section of the pull request's description, else the plan file in `ace/temporary-plans/` the diff builds.

When none of those sources holds a ticket or plan, skip this check. A missing one is not a failure.

## Find

Judge spec match only. Compare the diff with the ticket and its comments, or the plan; "ticket" below means either. Each of these is a finding:

- A requirement in the ticket is missing or only partly done.
- A requirement is present, and the implementation does the wrong thing. Quote the ticket line.
- The diff does something the ticket did not ask for.

## Severity

- A missing, partial, or wrong requirement is `blocker`.
- Work the ticket did not ask for is `should-fix`.

## Result

One line for the report:

- `Spec matches.` when there is no spec finding.
- `No linked ticket or plan. Spec check skipped.`
- `Spec diverges from TICKET.`, with the ticket reference or `the plan`, when there are spec findings. The findings follow in the report.
