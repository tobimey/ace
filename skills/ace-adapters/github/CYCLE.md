# Cycle: GitHub Actions

The built-in cycle for GitHub Actions. Ace uses it when `who_starts_runs` in `ace/config.json` is `github-actions`. A section in the project's `ace/CYCLE.md` replaces the section here with the same job.

How work moves from one stage of the Ace cycle to the next. `ace-mode` reads the hand-off for a playbook when that playbook ends. A playbook with no hand-off here gets the next step from `ace-mode`. Labels on tickets and pull requests carry the state, and GitHub Actions start the runs. `REPO` is `gh repo view --json nameWithOwner --jq .nameWithOwner`.

## Hand-offs

### After Build

When a pull request was opened or updated, and `review.runs` in `ace/config.json` includes `pull-request-opened` or `pull-request-pushed`, tell the user the review runs in GitHub Actions and posts its result on the pull request. When it includes neither, tell the user that adding the label `ace:review` starts one:

```bash
gh pr edit NUMBER --repo REPO --add-label ace:review
```

When no pull request was opened, tell the user that `Open a pull request` ships the change.

### After Review

When the review ran on a pull request that has the label `ace:review`, remove the label, so adding it again starts a new review:

```bash
gh pr edit NUMBER --repo REPO --remove-label ace:review
```

A person reads the review and merges the pull request.

## Runs

What starts an agent run without a person typing it. Each line applies only when its workflow file exists. The schedule and the audit domains are in that file.

- **A pull request opens or gets a push, as `review.runs` in `ace/config.json` says, or a person adds the label `ace:review`**: `.github/workflows/ace-review.yml` runs the agent with `Review pull request #NUMBER and comment on it.`
- **Its schedule, label `ace:ready` added to a ticket, or a manual run**: `.github/workflows/ace-work-ticket.yml` runs the agent with `Run ace-work-ticket.`
- **Its schedule, or a manual run for one domain**: `.github/workflows/ace-audit.yml` runs the agent once per domain in its matrix, with `Run ace-audit DOMAIN.`

A push, a pull request, or a label that a GitHub Actions run makes with the default `GITHUB_TOKEN` starts no other workflow. So `ace-work-ticket.yml` runs with the secret `ACE_GH_TOKEN`, a GitHub App token or a fine-grained personal access token. That way its pull request starts CI and the review.
