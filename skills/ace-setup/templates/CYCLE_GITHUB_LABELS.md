# Cycle

How work moves from one stage of the Ace cycle to the next in this project. `ace-mode` reads the hand-off for a playbook when that playbook ends. Labels on tickets and pull requests carry the state, and GitHub Actions start the runs.

## Hand-offs

### After Plan

Tell the user the tickets are open in the needs-dev state. `Implement TICKET` starts the first one with no blockers. Setting a ticket ready lets `ace-work-ticket` pick it up instead.

### After Build

When a pull request was opened or updated, add the label that starts a review run:

```bash
gh pr edit NUMBER --repo <REPO> --remove-label ace:reviewed --add-label ace:review
```

Then tell the user the review runs in GitHub Actions and posts its result on the pull request. Otherwise tell the user that `Open a pull request` ships the change.

### After Review

When the review ran on a pull request, swap the label, so adding `ace:review` again starts a new review:

```bash
gh pr edit NUMBER --repo <REPO> --remove-label ace:review --add-label ace:reviewed
```

A person reads the review and merges the pull request.

### After Audit

Tell the user the tickets that were opened. Each is in the needs-dev state: a person reads it and sets it ready, or closes it. `Implement TICKET` starts one by hand.

## Runs

What starts an agent run without a person typing it.

- **Label `ace:review` added to a pull request**: `.github/workflows/ace-review.yml` runs the agent with `Review pull request #NUMBER, fix what needs no decision, and comment on it.`
- **Schedule `<WORK_CRON>`, label `ace:ready` added to a ticket, or a manual run**: `.github/workflows/ace-work-ticket.yml` runs the agent with `Run ace-work-ticket.`
- **Schedule `<AUDIT_CRON>`, or a manual run for one domain**: `.github/workflows/ace-audit.yml` runs the agent once per domain in `<DOMAINS>`, with `Run ace-audit-DOMAIN.`

A push, a pull request, or a label that a GitHub Actions run makes with the default `GITHUB_TOKEN` starts no other workflow. So `ace-work-ticket.yml` runs with the secret `ACE_GH_TOKEN`, a GitHub App token or a fine-grained personal access token. That way its pull request starts CI and its `ace:review` label starts the review.
