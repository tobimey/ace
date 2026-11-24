# Pull requests: GitHub, open

Part of [PULL_REQUESTS.md](../PULL_REQUESTS.md), which says when Ace supports pull requests and defines `REPO` and `DEFAULT_BRANCH`.

## Open a pull request

Branch if needed, commit, push, open a pull request, then give the URLs.

### Constraints

- Ship exactly what is already in the tree.
- Pull request title and commit title use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`.
- Pull request body: the project's pull request template, wherever GitHub looks for one, in any letter case: `git ls-files | grep -iE '^(\.github/|docs/)?pull_request_template(\.md$|/)'`. In a `PULL_REQUEST_TEMPLATE/` folder, pick the file that fits the change. Keep its headings in order, fill each section, tick only the checkboxes that are true, and drop its instruction comments. With no template, write the sections What changed and How it was verified. Sign it as "Sign what you post" in [ADAPTERS.md](../../ADAPTERS.md) says.
- Read the diff and describe only what changed, plus what the caller asks the body to hold.
- Push with a plain push and let every hook run.
- Label every pull request `ace-created`, which says Ace opened it. Add other labels only when the caller asks.

### Steps

1. `git status`, `git diff`, `git log` against the default branch, current branch name.
2. If on `DEFAULT_BRANCH`, check out a short kebab-case branch from it. On any other branch, stay on it.
3. If the tree is dirty, `git add` the existing changes and commit with the title line only.
4. `git push -u origin HEAD`
5. Create the label `gh label create ace-created` when `gh label list --limit 200 --json name --jq '.[].name' | grep -qx ace-created` finds none. Then `gh pr create --draft --label ace-created --title "TITLE" --body "$(cat <<'EOF' ... EOF)"` with the filled template. Drop `--draft` when the user says ready, publish, or not draft.
6. Reply with both URLs, nothing more:

```
PR: <pr-url>
Branch: <https://github.com/<owner>/<repo>/tree/<branch>>
```
