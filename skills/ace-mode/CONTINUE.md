# Continue and hand off

Finds where the work stands and names the next step. `ace-mode` reads this file for the Continue playbook and at the end of every playbook that hands off.

## State table

Place the work in the first row that matches:

| State | Next |
|---|---|
| An idea with open decisions, and no spec ticket | Plan |
| A spec ticket too big for one change, with no sub-tickets | `ace-to-ticket` with that ticket |
| A ticket in the needs-dev state | A person reads it and its comments, then sets it ready or closes it |
| A ticket with no branch and no pull request | Build |
| Local changes, or a branch with no pull request | Review on the local diff, then `ace-open-pr` |
| An open pull request with failing checks, merge conflicts, or review comments with no reply | Babysit |
| An open pull request with no `<!-- ace-review -->` comment, or commits newer than that comment | Review |
| An open pull request with a current review | A person merges. Name its Merge Danger. |
| A merged pull request | Done. Offer a retro with `ace-optimize-factory` when the work went badly. |
| No ticket, pull request, or local change | Plan, starting with no direction |

## Continue

1. Find the work: the ticket or pull request the message names. Otherwise the pull request for the current branch, found as `ace/CODE_HOSTING.md` says. Otherwise the local diff.
2. Place it in the state table.
3. Say the state and the next step in two lines, in plain words. Run the matching playbook once the user agrees.

## Hand off

A person starts the next run, unless the cycle adapter `ace/CYCLE.md` says a label or a schedule does. With `who_starts_runs` set to `github-actions`, that is the built-in GitHub cycle, as `ace-adapters` says.

When Plan, Perf, Fix, Refactor, Build, Babysit, Review, or Audit ends, and `ace/CYCLE.md` has a section for that playbook, do what it says. Perf, Fix, Refactor, and Babysit use the Build section. The section can set a label, move a ticket, or tell the user what a run does next.

Otherwise end the reply with the next step from the state table, as one line the user can send, such as `Next: review pull request #12`. After Plan or Audit, also say which state the new tickets are in. For a ticket in needs-dev, say that a person sets it ready or starts it with `Implement TICKET`.
