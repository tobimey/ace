# Code hosting: GitHub

The built-in code host for GitHub. Ace uses it when `git remote get-url origin` points at github.com and `gh auth status` succeeds. A section in the project's `ace/CODE_HOSTING.md` replaces the section here with the same job, so a project overrides only what it does differently, such as its pull request rules.

- `REPO` is `gh repo view --json nameWithOwner --jq .nameWithOwner`.
- `DEFAULT_BRANCH` is `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, else `main`, else `master`.

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

## Open a pull request

Checkout a branch (if on the default branch), commit if needed, push, open a pull request, then give the URLs.

### Constraints

- Ship exactly what is already in the tree.
- Draft unless the user says otherwise (ready, publish, not draft).
- Pull request title and commit title use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`.
- Commit message is the title line only.
- Pull request body: the pull request template under `.github/`, such as `.github/pull_request_template.md`. Read it and fill exactly its sections. With no template, write the sections What changed and How it was verified.
- Read the diff and describe only what changed.
- Push with a plain push and let every hook run.
- If already on a non-default branch, stay on it. If on `DEFAULT_BRANCH`, create a short kebab-case branch from it first.
- Add labels only when the caller asks.

### Steps

1. `git status`, `git diff`, `git log` against the default branch, current branch name.
2. If on `DEFAULT_BRANCH`, checkout a new branch from it.
3. If the tree is dirty, `git add` the existing changes and commit with a conventional-commit title only.
4. `git push -u origin HEAD`
5. `gh pr create --draft --title "TITLE" --body "$(cat <<'EOF' ... EOF)"` with the filled template. Drop `--draft` when told not to draft.
6. Reply with both URLs, nothing more:

```
PR: <pr-url>
Branch: <https://github.com/<owner>/<repo>/tree/<branch>>
```

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

## Pull request state

The checks, unresolved review threads, reviews, new comments, and merge state of one pull request, with a verdict. Run [pr-state.sh](pr-state.sh):

```bash
pr-state.sh NUMBER --repo REPO
pr-state.sh NUMBER --repo REPO --wait 600
```

It prints JSON. `verdict` is `ACTION`, `WAITING`, `READY`, `MERGED`, or `CLOSED`, and `reasons` says why. `--wait` polls while the verdict is `WAITING`, up to that many seconds. Ace knows what it already answered by the marker `<!-- ace-babysit` that `ace-babysit-pr` puts on every reply, not by who posted it. A review or comment counts as new when it is newer than the head commit and newer than the latest Ace reply. An open thread whose last comment is an Ace reply, and requested changes that Ace already answered, wait for a person.

## Check logs

Read a failing check from `failing_checks` in the pull request state. With a `run_id`, it is a GitHub Actions run:

```bash
gh run view RUN_ID --repo REPO --log-failed > "$TMPDIR/ci.log"
grep -n -iE 'error|fail|panic|exception|assert' "$TMPDIR/ci.log" | head -n 50
```

Then read the lines around each hit. Without a `run_id`, the check is an outside service: open its `link`.

To run the failed jobs of a run once more:

```bash
gh run rerun RUN_ID --repo REPO --failed
```

## Reply to a review thread

Reply inside a review thread, then resolve it. Write the reply to a file first, so comment text stays out of the shell:

```bash
gh api graphql -F threadId=THREAD_ID -F body=@reply.md -f query='
mutation($threadId: ID!, $body: String!) {
  addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $threadId, body: $body}) { comment { url } }
}'
gh api graphql -F threadId=THREAD_ID -f query='
mutation($threadId: ID!) { resolveReviewThread(input: {threadId: $threadId}) { thread { isResolved } } }'
```

A review body or a plain pull request comment has no thread. Answer it with one comment as "Comment on a pull request" says, quoting the line you answer.

## Comment on a pull request

Post the caller's text on the pull request. Done means that text is on the pull request.

```bash
gh pr comment NUMBER --repo REPO --body "$(cat <<'EOF'
TEXT
EOF
)"
```

For an inline comment on a line, use `gh api repos/REPO/pulls/NUMBER/comments` with `body`, `commit_id`, `path`, `line`, and `side`.

To replace an earlier comment, find it by the marker the caller names, then edit it. If no comment holds the marker, post a new one as above.

```bash
gh api repos/REPO/issues/NUMBER/comments --paginate \
  --jq '.[] | select(.body | contains("MARKER")) | .id' | head -n 1
gh api -X PATCH repos/REPO/issues/comments/ID -f body="$(cat <<'EOF'
TEXT
EOF
)"
```

## Linked tickets

The tickets a pull request closes:

```bash
gh pr view NUMBER --repo REPO --json closingIssuesReferences,body,headRefName,commits
```

Use `closingIssuesReferences` first. Then look for ticket references in the body, the branch name, and the commit messages, in the form the "Ticket references" section of `ace/TICKET_TRACKER.md` names. A reference to this pull request itself is not a ticket.
