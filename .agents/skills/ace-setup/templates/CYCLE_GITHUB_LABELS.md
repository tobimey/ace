# Cycle

How work moves from one stage of the Ace cycle to the next in this project. `ace-mode` reads the hand-off for a playbook when that playbook ends. Labels on the pull request carry the state, and GitHub Actions start the runs.

## Hand-offs

### After Plan

Tell the user the tickets are ready, and that `Implement TICKET` starts the first one with no blockers.

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

Tell the user the tickets that were opened, and that `Implement TICKET` starts one.

## Runs

What starts an agent run without a person typing it.

- **Label `ace:review` added to a pull request**: `.github/workflows/ace-review.yml` runs the agent with `Review pull request #NUMBER, fix what needs no decision, and comment on it.`

A label that a GitHub Actions run adds with the default `GITHUB_TOKEN` starts no other workflow. When the Build playbook runs in GitHub Actions too, add the label with a GitHub App token or a personal access token.
