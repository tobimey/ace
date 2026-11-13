---
name: ace-pr-comment
description: Posts a pull request comment, review, or inline comment as the Cursor GitHub App.
disable-model-invocation: true
---

# Pull request comment

Post the caller's text on the pull request with this run's comment tools. Done means that text is on the pull request as `cursor`, the Cursor GitHub App.

Use `post_review_comment_on_pr` from the Cursor Automation Tools namespace. It posts a review. Pass `message` with the caller's text and `pr_url` with the pull request URL, `https://github.com/peaksandpies/hedwig/pull/N`. Do not rely on its default, which is the triggering pull request.

## Constraints

- Do not use `gh`, `GH_TOKEN`, or `GITHUB_TOKEN` to comment, to open a review, or to leave an inline comment. The PAT is the human who started this run.
- Do not fall back to `gh` when comment tools fail. Retry the comment tools, or stop.
- Use the PAT with `gh` for reads, label moves, and pull request body edits. Those are not comments.

## Example

Wrong: `gh pr comment 12 --body "Docs: no updates needed."` while `GH_TOKEN` is set. That posts as the human.

Right: this run's comment tools, same body. That posts as `cursor`.
