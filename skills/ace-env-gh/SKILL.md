---
name: ace-env-gh
description: Teaches GitHub CLI (gh) quirks and GitHub stacked pull requests. Use when running gh, creating or listing issues or pull requests, calling the GitHub API, using gh search or gh api, or when the user mentions gh, GitHub CLI, stacks, stacked PRs, gh stack, or ace-gh-stacked-prs.
---

# Ace env gh

Use `gh` correctly. Done means commands skip prompts, output is `--json`, and stacked PRs go through `gh stack`.

`gh <command> --help` is source of truth. Do not guess flags.

## Constraints

- Do not run TUI or prompt-only commands. Pass the flags that skip them.
- Do not set `GH_PAGER` or `GH_FORCE_TTY`. There is no `--no-pager`.
- Do not cache `gh auth token`. Prefer `gh api` so `gh` can refresh.
- Do not parse column output. Use `--json`.
- Do not `git push --force` after a stack push fails.
- Do not merge, prune, or unstack unless the user asked.
- Do not run concurrent stack mutations. Inspect `git status` first and keep unrelated changes.

## Quirks

Non-TTY `gh` errors instead of prompting. Agent sessions often still look like a TTY, so always pass `--title` and `--body` or `--body-file -`.

`--json field1,field2` is required before `--jq`. Omit the field list to see available fields. `--jq` is built in.

`-T`/`--template` is a PR/issue **body** template on create. On list/view it is Go-template output and needs `--json`.

`gh pr view --comments` is conversation comments. Inline review comments: `gh api repos/{owner}/{repo}/pulls/NUMBER/comments`.

`gh issue list`, `gh pr list`, and `gh search` default to 30 hits. Pass `-L N`. They have no `totalCount` in `--json`.

`gh search` takes each qualifier as its own token: `gh search issues repo:cli/cli is:open`. Quoting them as one string fails. `gh issue list --search "..."` is one quoted string, one repo.

`--author dependabot` matches nothing. Use `--app dependabot`.

`--label` fails if the label does not exist. `gh issue create --type NAME` and `--parent NUMBER` exist on current `gh`.

`gh pr checkout NUMBER` switches git state. Use `gh pr view` or `gh pr diff` to read.

`gh api` is GET, or POST if any `-f`/`-F` is set. `-f` sends strings literally (`body=@file` is the text `@file`). `-F` types values and reads `@file`. `--input -` is a raw body. `{owner}`/`{repo}` in the path fill from the current repo.

`GH_TOKEN` overrides stored credentials and is never refreshed. `-R OWNER/REPO` overrides the cwd repo. Projects need `gh auth refresh -s project`.

## Stacks

GitHub stacked PRs are new. Use `gh stack`, not guessed merge chains.

Check `gh auth status` and `gh stack --help`. If missing: `gh extension install github/gh-stack`. `gh stack help SUBCOMMAND` does not work. Use `gh stack SUBCOMMAND --help`. Exit 9 means the repo does not have stacked PRs.

A stack is linear: `(main) <- bottom <- ... <- top`. Each PR targets the branch below it. Bottom targets trunk. `up` moves away from trunk. Create the stack before writing files. One concern per layer.

```bash
gh stack init feature-foundation
# commit on this layer
gh stack add feature-api
# commit on this layer
gh stack submit --auto
gh stack view --json
```

`add` must run from the current top. `submit --auto` pushes, creates draft PRs, and links the stack. `--open` only when the user wants them ready for review.

Never run bare `view`, `submit`, `init`, `add`, `checkout`, `merge`, or `modify`. Those open a TUI. Use `view --json`, `submit --auto`, `init BRANCH`, `add BRANCH`, `checkout TARGET`, `merge TARGET --yes`. Restructure with `unstack` then `init`, not `modify`.

Existing stacks: `gh stack checkout <pr-or-branch>`. Navigate with `up`, `down`, `top`, `bottom`. After remote merges: `sync`. After adding layers: `submit --auto`.

Edit a lower layer on that branch, then `gh stack rebase --upstack` and `gh stack push`. Do not merge lower into upper by hand. Conflicts: resolve in the reported worktree, `git add`, `gh stack rebase --continue`. Abort: `gh stack rebase --abort`. Never push an unresolved rebase.

`push` updates branches. `submit` also creates/updates PRs. `sync` rebases only if trunk moved. After a lower-layer edit, rebase then push. Non-interactive `sync` can exit 0 on divergence with `Sync aborted`. Stop and inspect. That is not success.

`gh pr merge` cannot merge a stack. `gh stack merge 42 --yes` merges that PR and everything below it. Bare `--yes` merges the whole stack.

Report PR links, stack order, and unresolved issues.
