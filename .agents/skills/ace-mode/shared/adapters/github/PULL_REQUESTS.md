# Pull requests: GitHub

How Ace gets a diff and works with pull requests. Ace supports pull requests only on GitHub: `git remote get-url origin` points at github.com and `gh auth status` succeeds. Without that, there is no pull request: "Get the diff" skips step 2, "Find a pull request" finds none, and "Linked tickets" is skipped. Every other section stops with `Pull requests need GitHub and a logged-in gh.`

- `REPO` is `gh repo view --json nameWithOwner --jq .nameWithOwner`.
- `DEFAULT_BRANCH` is `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, else `main`, else `master`.

This file holds the sections that read. Each other section is in its own file. Read only the one you need:

- "Open a pull request": [pull-requests/OPEN.md](pull-requests/OPEN.md)
- "Comment on a pull request" and "Reply to a review thread": [pull-requests/COMMENT.md](pull-requests/COMMENT.md)
- "Pull request state" and "Check logs": [pull-requests/CI.md](pull-requests/CI.md)

## Get the diff

The diff a review job reads. Use the first that applies:

1. The caller passed a diff. Use it.
2. The caller passed a pull request. Run `gh pr diff NUMBER --repo REPO`.
3. The caller passed a base ref. Run `git diff REF`.
4. Otherwise, the current branch and uncommitted work against the default branch:

   ```bash
   git status --short
   git diff "$(git merge-base HEAD origin/DEFAULT_BRANCH 2>/dev/null || git merge-base HEAD DEFAULT_BRANCH)"
   ```

   Read untracked files that `git status --short` lists.

## Find a pull request

The pull request for a number or a branch, with its state, labels, and comments. With no number, use the current branch.

```bash
gh pr view NUMBER_OR_BRANCH --repo REPO \
  --json number,url,state,isDraft,labels,headRefName,comments,commits
```

No pull request for the branch means the work has none yet.

To check out its head branch, also from a detached checkout such as a CI job:

```bash
gh pr checkout NUMBER --repo REPO
```

To list the open pull requests of the current user, newest first:

```bash
gh pr list --repo REPO --author @me --state open \
  --json number,url,title,headRefName,isDraft,updatedAt
```

## Linked tickets

The tickets a pull request closes:

```bash
gh pr view NUMBER --repo REPO --json closingIssuesReferences,body,headRefName,commits
```

Use `closingIssuesReferences` first. Then look for ticket references in the body, the branch name, and the commit messages, in the form the "Ticket references" section of `ace/TICKET_TRACKER.md` names. A reference to this pull request itself is not a ticket.
