# `ace/CODE_HOSTING.md`

**GitHub** means `git remote get-url origin` points at github.com and `gh auth status` succeeds. A default that needs GitHub does not fit any other project.

| Section | What it holds | Used by | Default |
|---|---|---|---|
| Get the diff | How to get the change to review, from a diff, a pull request, a base ref, or the current branch | `ace-verify`, `ace-review`, `ace-explain` | That section of [github/CODE_HOSTING.md](../github/CODE_HOSTING.md), without the pull request case, which needs GitHub. |
| Open a pull request | How to branch, commit, push, and open a pull request, and what to hand back | `ace-open-pr` | None. Stop and offer `ace-setup hosting`. |
| Linked tickets | How to find the tickets a pull request closes, using the tracker's ticket references | `ace-review`, `ace-explain` | Skip |
| Find a pull request | How to find the pull request for a number or a branch, with its state, labels, and comments, how to check out its head branch, and how to list the current user's open pull requests | `ace-mode`, `ace-review`, `ace-babysit-pr` | There is no pull request. |
| Comment on a pull request | How to post a comment on a pull request, and how to find an earlier comment by a marker and edit it | `ace-explain`, `ace-mode`, `ace-babysit-pr`. The root agents file also points agents here | The comment goes in the reply. |
| Pull request state | The failing and running checks, unresolved review threads, reviews, new comments, and merge state of a pull request, with a verdict: action, waiting, ready, merged, or closed. A review, comment, or thread that a reply marked `<!-- ace-babysit` follows is answered, and waits for a person | `ace-babysit-pr` | None. Stop and offer `ace-setup hosting`. |
| Check logs | How to read the log of a failing check, and how to run it once more | `ace-babysit-pr` | None. Name the failing check and its link, and fix from the checks in `ace/VERIFY.md` run locally. |
| Reply to a review thread | How to reply inside a review thread and resolve it | `ace-babysit-pr` | The reply goes in the report. |

**Provider.** [github/CODE_HOSTING.md](../github/CODE_HOSTING.md) when the code is on GitHub. It needs no setting and fills every section above. So the defaults in the table apply only to code on another host with no `ace/CODE_HOSTING.md`.
