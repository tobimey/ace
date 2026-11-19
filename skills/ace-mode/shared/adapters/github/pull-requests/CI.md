# Pull requests: GitHub, state and checks

Ace supports pull requests only on GitHub: `git remote get-url origin` points at github.com and `gh auth status` succeeds. Without that, stop with `Pull requests need GitHub and a logged-in gh.` `REPO` is `gh repo view --json nameWithOwner --jq .nameWithOwner`.

## Pull request state

The checks, unresolved review threads, reviews, new comments, and merge state of one pull request, with a verdict. Run [pr-state.sh](../pr-state.sh), in the folder above this file:

```bash
pr-state.sh NUMBER --repo REPO
pr-state.sh NUMBER --repo REPO --wait 600
```

It prints JSON. `verdict` is `ACTION`, `WAITING`, `READY`, `MERGED`, or `CLOSED`, and `reasons` says why. A `READY` draft has the reason `draft`: a person marks it ready. `--wait` polls while the verdict is `WAITING`, up to that many seconds. Ace knows what it already answered by the marker `<!-- ace-babysit` that `ace-babysit-pr` puts on every reply, not by who posted it. A review or comment counts as new when it is newer than the head commit and newer than the latest Ace reply. The latest `<!-- ace-review -->` report counts as new when it holds findings and was edited after both, whoever posted it, and `review_report` describes it. An open thread whose last comment is an Ace reply, and requested changes that Ace already answered, wait for a person.

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
