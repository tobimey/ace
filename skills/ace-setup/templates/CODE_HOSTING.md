# Code hosting

Code lives on GitHub. Every ace skill that opens a pull request, comments on one, or reads the tickets a pull request closes follows this file.

## Open a pull request

Checkout a branch (if on the default branch), commit if needed, push, open a pull request, then give the URLs.

### Constraints

- Never edit, format, or "fix" files. Ship what is already in the tree.
- Draft unless the user says otherwise (ready, publish, not draft).
- Pull request title and commit title use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`.
- Commit message is the title only. No body.
- Pull request body is `<PR_TEMPLATE_PATH>`. Read that file and fill it. Do not invent extra sections. <PR_TEMPLATE_RULES>
- Do not invent scope. Read the diff and say what changed.
- No force push. No skipped hooks.
- If already on a non-default branch, stay on it. If on `<DEFAULT_BRANCH>`, create a short kebab-case branch from it first.
- Add `agent-created` only when the caller asks. Do not add a `pr-review-*` label. The caller adds `pr-review-1` when this pull request should enter the pipeline.

### Steps

1. `git status`, `git diff`, `git log` against the default branch, current branch name.
2. If on `<DEFAULT_BRANCH>`, checkout a new branch from it.
3. If the tree is dirty, `git add` the existing changes and commit with a conventional-commit title only.
4. `git push -u origin HEAD`
5. `gh pr create --draft --title "TITLE" --body "$(cat <<'EOF' ... EOF)"` with the filled template. Drop `--draft` when told not to draft.
6. If the caller asked for `agent-created`, run `gh pr edit NUMBER --add-label agent-created`.
7. Reply with both URLs, nothing more:

```
PR: <pr-url>
Branch: <https://github.com/<owner>/<repo>/tree/<branch>>
```

## Comment on a pull request

Post the caller's text on the pull request with this run's comment tools. Done means that text is on the pull request as `cursor`, the Cursor GitHub App.

Use `post_review_comment_on_pr` from the Cursor Automation Tools namespace. It posts a review. Pass `message` with the caller's text and `pr_url` with the pull request URL, `https://github.com/<REPO>/pull/N`. Do not rely on its default, which is the triggering pull request.

### Constraints

- Do not use `gh`, `GH_TOKEN`, or `GITHUB_TOKEN` to comment, to open a review, or to leave an inline comment. The PAT is the human who started this run.
- Do not fall back to `gh` when comment tools fail. Retry the comment tools, or stop.
- Use the PAT with `gh` for reads, label moves, and pull request body edits. Those are not comments.

### Example

Wrong: `gh pr comment 12 --body "Docs: no updates needed."` while `GH_TOKEN` is set. That posts as the human.

Right: this run's comment tools, same body. That posts as `cursor`.

## Linked tickets

The tickets a pull request closes:

```bash
gh pr view NUMBER --json closingIssuesReferences,body
```

Use `closingIssuesReferences` first, then `Closes #N`, `Fixes #N`, or a bare `#N` in the body.
