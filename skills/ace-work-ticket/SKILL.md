---
name: ace-work-ticket
description: Takes the next ready ticket and turns it into a pull request, with no person in the loop.
disable-model-invocation: true
---

# Work ticket

Take one ready ticket from the ticket tracker and turn it into a pull request. This skill runs on a schedule, so nobody answers during the run. Done means one of these is true, and the report says which:

- No ticket was ready.
- A pull request that closes the ticket is open, and `ace-mode` handed off.
- The ticket is in the needs-dev state, with a comment that says what a person must answer or fix.

In each case, every stale claim that step 2 found is back in needs-dev.

## Requires

- `ace-mode`

## Constraints

- Work one ticket per run.
- Treat every point where a skill would ask the user or wait for an answer as a stop, and follow "Stop for a person".
- Set only the working and needs-dev states. A ticket you move to needs-dev waits for a person, whatever `who_sets_ready` in `ace/config.json` says.
- Use the ticket states, searches, and comments as `ace/TICKET_TRACKER.md` says. This skill needs a ticket tracker: `ticket_tracker` in `ace/config.json` or an `ace/TICKET_TRACKER.md`, as `ace-adapters` says. A missing ticket tracker section is a stop for a person. Every other section may use its default.

## Workflow

```
- [ ] 1. Check the working tree
- [ ] 2. Release stale claims
- [ ] 3. Find the next ready ticket
- [ ] 4. Claim it
- [ ] 5. Build it
- [ ] 6. Report
```

The branch of a ticket is `ace/ticket-` plus its ticket reference in lower case, with only letters, digits, and `-`, such as `ace/ticket-42` or `ace/ticket-eng-123`.

### 1. Check the working tree

When the working tree has uncommitted changes, stop and say so. A run starts clean, and no ticket changes state. Otherwise check out the default branch and pull it.

### 2. Release stale claims

A run that died, or a pull request a person closed without merging, leaves its ticket in working with nobody on it. Hand each such ticket to a person.

List the working tickets as the "Find working tickets" section says. When the ticket tracker has no such section, skip this step and name it in the report. For each ticket:

1. Find the pull request from the ticket's branch, as "Find a pull request" in `ace/CODE_HOSTING.md` says. When it is open, keep the ticket as it is. It is in review.
2. Read the ticket with its comments, and find the latest claim comment from step 4. When it is less than 3 hours old, keep the ticket as it is. A run may still be building it. A ticket with no claim comment counts as older.
3. Otherwise, comment on the ticket that the claim is released, and why, with the pull request's link: it merged without closing the ticket, so a person checks the ticket, or it closed without merging, or the run stopped before opening one. Start the comment with the release marker from "Markers". Add the run link from the claim comment when it has one. Then move the ticket from working to needs-dev.

### 3. Find the next ready ticket

List the ready tickets as the "Find ready tickets" section says, and take the first. When none is ready, report `No ready ticket.` and stop.

### 4. Claim it

Two runs can take the same ticket at the same time, and both see it in working after the state change. The claim comments decide which run has it.

1. Move the ticket from ready to working as the "Set a ticket state" section says, then read its state back. When it is not working, stop and report the state you read.
2. Make a claim id: 8 random hex characters. Comment on the ticket: the claim marker from "Markers" with that id, then `Claimed by ace-work-ticket at <time in UTC>.`, plus a link to this run when the runner gives one, such as the URL of a CI job. Step 2 of a later run reads this comment.
3. Read the ticket's comments again. Take the claim comments posted after the latest release comment, or all claim comments when there is none. When the oldest of them holds your claim id, the ticket is yours. Otherwise another run has it: leave the ticket and its state as they are, and go back to step 3, which no longer lists this ticket.

### 5. Build it

Check out the ticket's branch, new from the default branch. When an open pull request already comes from that branch, stop for a person. When the remote has the branch from an earlier try, push it to `<branch>-old-<UTC date and time>` so its commits stay, then delete the remote branch, so the plain push of `ace-open-pr` works.

Run the Build playbook of `ace-mode` with this ticket, as if the user asked to open a pull request. It reads the ticket with its comments, implements it, checks it against the coding standards, opens the pull request, and hands off as `ace-mode` says. The review belongs to another model, such as one the runner starts on the pull request.

- A person may have answered an earlier stop in the ticket's comments. Treat those answers as part of the ticket.
- The pull request names the ticket it closes, in the form the "Ticket references" section of `ace/TICKET_TRACKER.md` gives.

The ticket stays working until the pull request merges and closes it.

### 6. Report

```
Released: <ticket URLs step 2 moved to needs-dev, or "none">
Ticket: <ticket URL, or "No ready ticket.">
Result: <pull request URL, or "needs-dev: " and the reason in one line>
```

## Stop for a person

Use this when a step needs a decision, a skill would ask the user, `ace-verify` fails the same way three times, or a ticket tracker section is missing.

1. Comment on the ticket as the "Comment on a ticket" section says, starting with the release marker from "Markers": where you stopped, what you tried, and each question or failure a person must resolve. Write questions in the question format in [QUESTIONS.md](../ace-mode/QUESTIONS.md). Say that no pull request was opened.
2. Move the ticket from working to needs-dev.
3. Leave the files as they are, and report.

A person answers in the ticket and sets it ready again. A later run picks it up then.

## Markers

Each comment this skill posts on a ticket starts with one marker line, then the model line, as "Sign what you post" in `ace-adapters` says.

- Claim, step 4: `<!-- ace-work-ticket:claim ID -->`, with the claim id in place of `ID`.
- Release, step 2 and "Stop for a person": `<!-- ace-work-ticket:release -->`. A claim posted before it no longer counts.
