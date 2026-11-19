# Pull requests: GitHub, open

Ace supports pull requests only on GitHub: `git remote get-url origin` points at github.com and `gh auth status` succeeds. Without that, stop with `Pull requests need GitHub and a logged-in gh.`

- `DEFAULT_BRANCH` is `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix, else `main`, else `master`.

## Open a pull request

Checkout a branch (if on the default branch), commit if needed, push, open a pull request, then give the URLs.

### Constraints

- Ship exactly what is already in the tree.
- Draft unless the user says otherwise (ready, publish, not draft).
- Pull request title and commit title use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`.
- Commit message is the title line only.
- Pull request body: the project's pull request template, wherever GitHub looks for one, in any letter case: `git ls-files | grep -iE '^(\.github/|docs/)?pull_request_template(\.md$|/)'`. In a `PULL_REQUEST_TEMPLATE/` folder, pick the file that fits the change. Keep its headings in order, fill each section, tick only the checkboxes that are true, and drop its instruction comments. With no template, write the sections What changed and How it was verified.
- Read the diff and describe only what changed.
- Push with a plain push and let every hook run.
- If already on a non-default branch, stay on it. If on `DEFAULT_BRANCH`, create a short kebab-case branch from it first.
- Label every pull request `ace-created`, which says Ace opened it. Add other labels only when the caller asks.

### Steps

1. `git status`, `git diff`, `git log` against the default branch, current branch name.
2. If on `DEFAULT_BRANCH`, checkout a new branch from it.
3. If the tree is dirty, `git add` the existing changes and commit with a conventional-commit title only.
4. `git push -u origin HEAD`
5. Create the label `gh label create ace-created` when `gh label list --limit 200 --json name --jq '.[].name' | grep -qx ace-created` finds none. Then `gh pr create --draft --label ace-created --title "TITLE" --body "$(cat <<'EOF' ... EOF)"` with the filled template. Drop `--draft` when told not to draft.
6. Reply with both URLs, nothing more:

```
PR: <pr-url>
Branch: <https://github.com/<owner>/<repo>/tree/<branch>>
```
