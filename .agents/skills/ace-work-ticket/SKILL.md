---
name: ace-work-ticket
description: Takes the next ready ticket and turns it into a pull request, with no person in the loop.
disable-model-invocation: true
---

# Work ticket

Take one ready ticket from the ticket tracker and turn it into a pull request. This skill runs on a schedule, so nobody answers during the run. Done means one of these is true, and the report says which:

- No ticket was ready.
- A pull request that closes the ticket is open, and `ace-mode` handed off.
- The ticket is in the needs-human state, with a comment that says what a person must answer or fix.
- The ticket is closed, with a comment that shows why.

In each case, every stale ticket that step 2 found is back in needs-human.

## Requires

- `ace-mode`

## Constraints

- Work one ticket per run. Treat a ticket in working with no open pull request as stale only when its claim comment is at least 90 minutes old, so overlapping runs leave active work alone.
- Treat every point where a skill would ask the user or wait for an answer as a stop, and follow "Stop for a person".
- Set only the working and needs-human states, and close a ticket only as step 4 says. A ticket you move to needs-human waits for a person, whatever `autonomy` in `ace/config.json` says.
- Read `autonomy` in `ace/config.json` as [ADAPTERS.md](../ace-mode/shared/adapters/ADAPTERS.md) says. At `high`, step 4 closes a rejected ticket. Otherwise it moves it to needs-human.
- Use the ticket states, searches, and comments as `ace/TICKET_TRACKER.md` says. This skill needs a ticket tracker: `ticket_tracker` in `ace/config.json` or an `ace/TICKET_TRACKER.md`, as [ADAPTERS.md](../ace-mode/shared/adapters/ADAPTERS.md) says. A missing ticket tracker section is a stop for a person. Every other section may use its default.

## Workflow

```
- [ ] 1. Check the working tree
- [ ] 2. Release stale tickets
- [ ] 3. Find the next ready ticket
- [ ] 4. Check it
- [ ] 5. Claim it
- [ ] 6. Build it
- [ ] 7. Report
```

The branch of a ticket is `ace/ticket-` plus its ticket reference in lower case, with only letters, digits, and `-`, such as `ace/ticket-42` or `ace/ticket-eng-123`.

### 1. Check the working tree

When the working tree has uncommitted changes, stop and say so. A run starts clean, and no ticket changes state. Otherwise check out the default branch and pull it.

### 2. Release stale tickets

A run that died, or a pull request a person closed without merging, leaves its ticket in working with nobody on it. Hand each such ticket to a person.

List the working tickets as the "Find working tickets" section says. When the ticket tracker has no such section, skip this step and name it in the report. For each ticket, find the pull request from the ticket's branch, as "Find a pull request" in [PULL_REQUESTS.md](../ace-mode/shared/adapters/github/PULL_REQUESTS.md) says. When it is open, keep the ticket as it is. It is in review. When no pull request exists and the latest `ace-work-ticket` claim comment is under 90 minutes old, keep it as active. Otherwise, comment on the ticket why it goes back, with the pull request's link: it merged without closing the ticket, so a person checks the ticket, or it closed without merging, or the run stopped before opening one. Then move the ticket from working to needs-human.

### 3. Find the next ready ticket

List the ready tickets as the "Find ready tickets" section says, and take the first. When none is ready, or step 4 skipped each one, report `No ready ticket.` and stop.

### 4. Check it

Before you claim the ticket, check it against the default branch. Take the first row that applies. When none does, claim it.

| The ticket | Then |
|---|---|
| An open pull request already closes or names it | Skip it, and take the next ready ticket |
| The default branch already does what it asks, or what it claims is wrong, such as a bug that does not reproduce | Reject it |
| It goes against what `ace/PRODUCT.md` leaves alone | Stop for a person, and quote that line |
| Done is unclear, or it needs more than one pull request | Stop for a person, with your questions or a split for `ace-to-ticket` |

To reject it, comment the evidence on the ticket: a commit, `file:line`, passing test, or the steps that did not reproduce the bug. Then close it, as the "Comment on a ticket" section says, when `autonomy` is `high`. Otherwise move it to needs-human. Report, and end the run.

### 5. Claim it

Move the ticket from ready to working as the "Set a ticket state" section says. Comment on the ticket that `ace-work-ticket` works on it, with a link to this run when the runner gives one, such as the URL of a CI job.

### 6. Build it

Check out the ticket's branch, new from the default branch. When the remote has the branch from an earlier try, push it to `<branch>-old-<UTC date and time>` so its commits stay, then delete the remote branch, so the plain push of `ace-open-pr` works.

Run the Build playbook of `ace-mode` with this ticket, as if the user asked to open a pull request: ready for review, or a draft when the message asks for one. It reads the ticket with its comments, implements it, checks it against the coding standards, opens the pull request, and hands off as `ace-mode` says. The review belongs to another model, such as one the runner starts on the pull request.

A person may have answered an earlier stop in the ticket's comments. Treat those answers as part of the ticket.

The ticket stays working until the pull request merges and closes it.

### 7. Report

```
Released: <ticket URLs step 2 moved to needs-human, or "none">
Skipped: <ticket URLs step 4 skipped, or "none">
Ticket: <ticket URL, or "No ready ticket.">
Result: <pull request URL, or "needs-human: " or "closed: " and the reason in one line>
```

## Stop for a person

Use this when a step needs a decision, a skill would ask the user, `ace-verify` fails the same way three times, or a ticket tracker section is missing.

1. Comment on the ticket as the "Comment on a ticket" section says: where you stopped, what you tried, and each question or failure a person must resolve. Write questions in the question format in [QUESTIONS.md](../ace-mode/QUESTIONS.md). Say that no pull request was opened.
2. Move the ticket to needs-human.
3. Leave the files as they are, and report.

A person answers in the ticket and sets it ready again. A later run picks it up then.
