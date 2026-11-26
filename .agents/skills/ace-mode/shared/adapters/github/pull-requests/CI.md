# Pull requests: GitHub, state and checks

Part of [PULL_REQUESTS.md](../PULL_REQUESTS.md), which says when Ace supports pull requests and defines `REPO`.

## Pull request state

The checks, unresolved review threads, reviews, new comments, and merge state of one pull request, with a verdict. Run [pr-state.sh](../pr-state.sh), in the folder above this file:

```bash
pr-state.sh NUMBER --repo REPO
pr-state.sh NUMBER --repo REPO --wait 90
```

It prints JSON. `verdict` is `ACTION`, `WAITING`, `READY`, `MERGED`, or `CLOSED`, and `reasons` says why. A `READY` draft has the reason `draft`: a person marks it ready. `--wait` polls while the verdict is `WAITING`, up to 90 seconds per call; re-run it to keep waiting. `review_reports` lists the latest `<!-- ace-review -->` report of each set of checks. `pr-state.sh --help` says what counts as new and which Ace replies wait for a person.

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
