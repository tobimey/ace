# `ace/TICKET_TRACKER.md`

| Section | What it holds | Used by |
|---|---|---|
| Ticket references | How a ticket is written in a commit, branch name, or pull request body, such as `#123` or `ENG-123` | `ace-review`, `ace-open-pr`, [PULL_REQUESTS.md](../github/PULL_REQUESTS.md) |
| Read a ticket | How to read a ticket with its comments | `ace-review`, `ace-grill`, `ace-to-ticket`, `ace-explain` |
| Search tickets | How to search tickets by text | `ace-audit`, `ace-explain` |
| Open a ticket | How to open a ticket with title, body, type, and Risk, in the needs-human state with a mark that Ace opened it, such as the label `ace-created`, and where Priority and Size go when the tracker records them | `ace-to-ticket` (its `OPEN_TICKET.md`) |
| Update a ticket | How to change a ticket's title, body, type, and Risk, and Priority and Size when the tracker records them | `ace-to-ticket` |
| Sub-tickets and blocking | How to attach a sub-ticket to a parent and mark a blocker | `ace-to-ticket` |
| Ticket states | How the tracker shows each ticket state: needs-human, ready, and working | `ace-work-ticket`, the user |
| Find ready tickets | How to list open tickets in the ready state that no open ticket blocks, in the order to work them | `ace-work-ticket` |
| Find working tickets | How to list open tickets in the working state | `ace-work-ticket`, to release claims a dead run left |
| Set a ticket state | How to move a ticket from one state to another, and read its state back | `ace-work-ticket` |
| Comment on a ticket | How to post a comment on a ticket, and how to close one | `ace-work-ticket`, `ace-to-ticket` |

**Provider.** [github/TICKET_TRACKER.md](../github/TICKET_TRACKER.md) when `ticket_tracker` in `ace/config.json` is `github-issues`. It fills every section above. Without that key, `ace/TICKET_TRACKER.md` is the whole tracker.

**Default.** No ticket tracker, also on GitHub, because a ticket opened by mistake is public. Every ticket step is a skip, except "Open a ticket": the skill writes the title, type, Priority, Size, Risk, and body into the reply, says no ticket tracker is set up, and offers `ace-setup tickets`.

The ticket states:

- **needs-human**: a person must look at the ticket. Every ticket an agent opens starts here, and `ace-work-ticket` moves a ticket here when it stops for a person.
- **ready**: an agent may work the ticket. A person sets it, or, at `high` `autonomy` in `ace/config.json`, the planning skill that opened it for a plan a person approved.
- **working**: `ace-work-ticket` claimed the ticket. It stays until the pull request merges and closes it. When no pull request is open for it, the next `ace-work-ticket` run moves it to needs-human with a comment that says why.

A ticket in none of these states is outside the agent queue, such as one a person builds. Who opened a ticket is no state: the mark from "Open a ticket" stays for good.
