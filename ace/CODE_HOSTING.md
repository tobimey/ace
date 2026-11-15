# Code hosting

Code lives on GitHub. Every ace skill that reads a diff, opens a pull request, comments on one, or reads the tickets a pull request closes follows this file.

**Pull request review is not in use for now.** Do not review a pull request, comment on one, or read its linked tickets. Review jobs read the local diff (step 3 or 4 under "Get the diff"). Open a pull request only when I ask for one.

## Get the diff

The diff a review job reads. Use the first that applies:

1. The caller passed a diff. Use it.
2. The caller passed a pull request. Run `gh pr diff NUMBER --repo tobimey/ace`.
3. The caller passed a base ref. Run `git diff REF`.
4. Otherwise, the current branch and uncommitted work against the default branch:

   ```bash
   git status --short
   git diff "$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main)"
   ```

   Read untracked files that `git status --short` lists.

## Open a pull request

Checkout a branch (if on the default branch), commit if needed, push, open a pull request, then give the URLs.

### Constraints

- Never edit, format, or "fix" files. Ship what is already in the tree.
- Draft unless the user says otherwise (ready, publish, not draft).
- Pull request title and commit title use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`.
- Commit message is the title only. No body.
- Pull request body is a short summary of what changed. There is no template.
- Do not invent scope. Read the diff and say what changed.
- No force push. No skipped hooks.
- If already on a non-default branch, stay on it. If on `main`, create a short kebab-case branch from it first.
- Add `agent-created` only when the caller asks. Add no other label unless the caller asks.

### Steps

1. `git status`, `git diff`, `git log` against the default branch, current branch name.
2. If on `main`, checkout a new branch from it.
3. If the tree is dirty, `git add` the existing changes and commit with a conventional-commit title only.
4. `git push -u origin HEAD`
5. `gh pr create --draft --title "TITLE" --body "$(cat <<'EOF' ... EOF)"` with the short summary. Drop `--draft` when told not to draft.
6. If the caller asked for `agent-created`, run `gh pr edit NUMBER --add-label agent-created`.
7. Reply with both URLs, nothing more:

```
PR: <pr-url>
Branch: <https://github.com/tobimey/ace/tree/<branch>>
```

## Comment on a pull request

Post the caller's text on the pull request. Done means that text is on the pull request.

```bash
gh pr comment NUMBER --repo tobimey/ace --body "$(cat <<'EOF'
TEXT
EOF
)"
```

For an inline comment on a line, use `gh api repos/tobimey/ace/pulls/NUMBER/comments` with `body`, `commit_id`, `path`, `line`, and `side`.

## Linked tickets

The tickets a pull request closes:

```bash
gh pr view NUMBER --json closingIssuesReferences,body
```

Use `closingIssuesReferences` first, then `Closes #N`, `Fixes #N`, or a bare `#N` in the body.
