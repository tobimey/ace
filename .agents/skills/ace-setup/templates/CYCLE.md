# Cycle

How work moves from one stage of the Ace cycle to the next in this project. `ace-mode` reads the hand-off for a playbook when that playbook ends. In this project a person starts every run.

## Hand-offs

### After Plan

Tell the user the tickets are open in the needs-dev state. `Implement TICKET` starts the first one with no blockers. Setting a ticket ready lets `ace-work-ticket` pick it up instead.

### After Build

When a pull request was opened, tell the user that `Review pull request #NUMBER and comment on it` reviews it. Otherwise tell the user that `Open a pull request` ships the change.

### After Review

Tell the user the Merge Danger, and that a person merges the pull request.

### After Audit

Tell the user the tickets that were opened. Each is in the needs-dev state: a person reads it and sets it ready, or closes it. `Implement TICKET` starts one by hand.

## Runs

What starts an agent run without a person typing it.

None.
