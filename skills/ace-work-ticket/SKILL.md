---
name: ace-work-ticket
description: Takes the next ready ticket and turns it into a reviewed pull request, with no person in the loop.
disable-model-invocation: true
---

# Work ticket

Take one ready ticket from the ticket tracker and turn it into a pull request. This skill runs on a schedule, so nobody answers during the run. Done means one of these is true, and the report says which:

- No ticket was ready.
- A pull request that closes the ticket is open, and the hand-off in `ace/CYCLE.md` ran.
- The ticket is in the needs-dev state, with a comment that says what a person must answer or fix.

## Requires

- `ace-mode`
- `ace-unslop`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Constraints

- Work one ticket per run.
- Treat every point where a skill would ask the user or wait for an answer as a stop, and follow "Stop for a person".
- Set only the working and needs-dev states. A person sets ready.
- Use the ticket states, searches, and comments as `ace/TICKET_TRACKER.md` says. Find each adapter section by its job. If a file or a section is missing, name it, say what it must hold, and stop.

## Workflow

```
- [ ] 1. Check the working tree
- [ ] 2. Find the next ready ticket
- [ ] 3. Claim it
- [ ] 4. Build it
- [ ] 5. Report
```

### 1. Check the working tree

When the working tree has uncommitted changes, stop and say so. A run starts clean, and no ticket changes state. Otherwise check out the default branch and pull it.

### 2. Find the next ready ticket

List the ready tickets as the "Find ready tickets" section says, and take the first. When none is ready, report `No ready ticket.` and stop.

### 3. Claim it

Move the ticket from ready to working as the "Set a ticket state" section says, then read its state back. When it is not working, another run has it. Stop and report that.

### 4. Build it

Run the Build playbook of `ace-mode` with this ticket, as if the user asked to open a pull request. It reads the ticket with its comments, implements it, reviews it, opens the pull request, and hands off as `ace/CYCLE.md` says.

- A person may have answered an earlier stop in the ticket's comments. Treat those answers as part of the ticket.
- The pull request names the ticket it closes, in the form the "Ticket references" section of `ace/TICKET_TRACKER.md` gives.
- When the review ran on the local diff, post its reply on the pull request as the last step of the Review playbook says.

The ticket stays working until the pull request merges and closes it.

### 5. Report

```
Ticket: <ticket URL, or "No ready ticket.">
Result: <pull request URL, or "needs-dev: " and the reason in one line>
```

## Stop for a person

Use this when a step needs a decision, a skill would ask the user, `ace-verify` fails the same way three times, or an adapter section is missing.

1. Comment on the ticket as the "Comment on a ticket" section says: where you stopped, what you tried, and each question or failure a person must resolve. Write questions in the question format of `ace-unslop`. Say that no pull request was opened.
2. Move the ticket from working to needs-dev.
3. Leave the files as they are, and report.

A person answers in the ticket and sets it ready again. A later run picks it up then.
