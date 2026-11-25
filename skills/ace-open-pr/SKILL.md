---
name: ace-open-pr
description: Opens a pull request for the current work on GitHub.
disable-model-invocation: true
---

# Open pull request

Open a pull request on GitHub for the current work, following [PULL_REQUESTS.md](../ace-mode/shared/adapters/github/PULL_REQUESTS.md) for GitHub support, `REPO`, and `DEFAULT_BRANCH`. Done means the pull request exists, its body names any ticket it closes, holds the plan from `ace/temporary-plans/` it builds, and names any proposed verify file changes from `ace-verify` not in the tree, and both URLs are handed back.

## Constraints

- Ship exactly what is already in the tree.
- Pull request title and commit title use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`.
- Pull request body: use the project's pull request template (`git ls-files | grep -iE '^(\.github/|docs/)?pull_request_template(\.md$|/)'`), picking the matching file in `PULL_REQUEST_TEMPLATE/`. Keep headings in order, fill each section, tick true checkboxes, and drop instruction comments. With no template, write `What changed` and `How it was verified`. Sign it as "Sign what you post" in [ADAPTERS.md](../ace-mode/shared/adapters/ADAPTERS.md) says.
- Describe only what the diff changes, plus:
  - **Ticket**: name the ticket it closes in the form "Ticket references" in `ace/TICKET_TRACKER.md` gives, such as `Closes #42`.
  - **Verify file proposals**: copy each proposed line with its file path from `ace-verify` that the tree lacks, noting a person adds them. Place both in the fitting template section, or add `Proposed verify file changes` at the end.
  - **Plan**: when the work builds a plan file in `ace/temporary-plans/`, copy it into a `Plan` section at the end, so a review elsewhere can check against it, and delete the file before you commit.
- Push with a plain push and let every hook run.
- Label every pull request `ace-created`. Add other labels only when the caller asks.

## Steps

1. Check `git status`, `git diff`, `git log` against `DEFAULT_BRANCH`, and the current branch name.
2. On `DEFAULT_BRANCH`, check out a short kebab-case branch from it. On any other branch, stay on it.
3. If the tree is dirty, `git add` the existing changes and commit with the title line only.
4. `git push -u origin HEAD`
5. Create `ace-created` when `gh label list --limit 200 --json name --jq '.[].name' | grep -qx ace-created` finds none. Then run `gh pr create --draft --label ace-created --title "TITLE" --body "$(cat <<'EOF' ... EOF)"`. Drop `--draft` when the user says ready, publish, or not draft.
6. Reply with both URLs, nothing more:

```
PR: <pr-url>
Branch: <https://github.com/<owner>/<repo>/tree/<branch>>
```
