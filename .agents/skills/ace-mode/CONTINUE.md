# Continue and hand off

Finds where the work stands and names the next step.

## State table

Place the work in the first row that matches:

| State | Next |
|---|---|
| An idea with open decisions, and no spec ticket | Plan |
| A spec ticket too big for one change, with no sub-tickets | `ace-to-ticket` with that ticket |
| A ticket in the needs-human state | A person reads it and its comments, then sets it ready or closes it |
| A ticket in the working state with no open pull request | Its run stopped. A later `ace-work-ticket` run moves it to needs-human, as the working state in [contract/TICKET_TRACKER.md](shared/adapters/contract/TICKET_TRACKER.md) says, or a person moves it now |
| A ticket with no branch and no pull request | Build |
| Local changes, or a branch with no pull request | `ace-open-pr`, then Review, best with a model other than the one that built the change |
| An open pull request with failing checks, merge conflicts, or review comments with no reply | Babysit |
| An open pull request with no `<!-- ace-review -->` comment | Review, best with a model other than the one that built the change |
| An open pull request with an `<!-- ace-review -->` comment | A person marks a draft ready, then merges, or asks for another review. Name its Merge Danger. |
| A merged pull request | Done. Offer a retro with `ace-optimize-factory` when the work went badly. |
| No ticket, pull request, or local change | Plan, starting with no direction |

## Continue

1. Find the work: the ticket or pull request the message names. Otherwise the pull request for the current branch, found as [PULL_REQUESTS.md](shared/adapters/github/PULL_REQUESTS.md) says. Otherwise the local diff.
2. Place it in the state table.
3. Say the state and the next step in two lines, in plain words. Run the matching playbook once the user agrees.

## Hand off

When `ace/CYCLE.md` has a section for the playbook that ended, do what it says. Perf, Fix, Refactor, and Garden use the Build section. Babysit uses none, so its pushes start no new review. The section can set a label, move a ticket, or tell the user what a run does next.

Otherwise end the reply with one closing line from the state table that the user can send, such as `Next: open a PR, or review the diff (best on another model)`. Do not stack extra offers above it. After Plan or Audit, also say which state the new tickets are in. For a ticket in needs-human, say that a person sets it ready or starts it with `Implement TICKET`.
