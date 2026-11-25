# Pull requests: GitHub, comment

Part of [PULL_REQUESTS.md](../PULL_REQUESTS.md), which says when Ace supports pull requests and defines `REPO`.

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

## Update the description

Put the caller's block into the pull request description between `<!-- MARKER -->` and `<!-- /MARKER -->`. Replace an earlier block with that marker, else append it at the end. Keep the rest of the description as it is.

```bash
gh pr view NUMBER --repo REPO --json body --jq .body > body.md
# edit the marked block in body.md
gh pr edit NUMBER --repo REPO --body-file body.md
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
