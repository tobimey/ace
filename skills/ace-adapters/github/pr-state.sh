#!/usr/bin/env bash
# Prints the state of one GitHub pull request as JSON, with a verdict.
# Usage: pr-state.sh NUMBER [--repo OWNER/NAME] [--wait SECONDS]
#   --wait  poll every 30 seconds while the verdict is WAITING, up to SECONDS.
# Needs gh (authenticated) and jq.
# Exit 0: READY, MERGED, or CLOSED. 1: ACTION. 3: WAITING. 2: bad input.
#
# Verdict:
#   ACTION   conflicts, a failing check, an unresolved review thread,
#            requested changes, or a comment newer than the head commit
#   WAITING  checks still running, or a required review is missing
#   READY    nothing left for an agent
set -euo pipefail

number=""
repo=""
wait_for=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --repo) repo="$2"; shift 2 ;;
    --wait) wait_for="$2"; shift 2 ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) number="$1"; shift ;;
  esac
done

case "$number" in
  ''|*[!0-9]*) echo "usage: pr-state.sh NUMBER [--repo OWNER/NAME] [--wait SECONDS]" >&2; exit 2 ;;
esac
[ -n "$repo" ] || repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
owner=${repo%%/*}
name=${repo#*/}

query='
query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      number url state isDraft isCrossRepository
      headRefName baseRefName headRefOid
      mergeable mergeStateStatus reviewDecision
      author { login }
      commits(last: 1) { nodes { commit { committedDate statusCheckRollup { contexts(first: 100) { nodes {
        __typename
        ... on CheckRun { name status conclusion detailsUrl
          isRequired(pullRequestNumber: $number)
          checkSuite { workflowRun { databaseId workflow { name } } } }
        ... on StatusContext { context state targetUrl
          isRequired(pullRequestNumber: $number) }
      } } } } } }
      reviewThreads(first: 100) { nodes {
        id isResolved isOutdated path line
        comments(first: 50) { nodes { databaseId author { login } body createdAt url } }
      } }
      reviews(last: 50) { nodes { author { login } state body submittedAt url } }
      comments(last: 100) { nodes { author { login } body createdAt url } }
    }
  }
}'

shape='
def ci_bot: test("^(github-actions|vercel|netlify|codecov|dependabot|renovate)(\\[bot\\])?$");
.data.repository.pullRequest as $pr
| ($pr.commits.nodes[0].commit) as $head
| $head.committedDate as $since
| $pr.author.login as $me
| ([$head.statusCheckRollup.contexts.nodes[]? |
    if .__typename == "CheckRun" then
      { name: ((.checkSuite.workflowRun.workflow.name // "") + (if .checkSuite.workflowRun then " / " else "" end) + .name),
        required: .isRequired,
        state: (if .status != "COMPLETED" then "PENDING"
                elif (.conclusion | IN("SUCCESS", "NEUTRAL", "SKIPPED")) then "PASS"
                else "FAIL" end),
        conclusion, run_id: .checkSuite.workflowRun.databaseId, link: .detailsUrl }
    else
      { name: .context, required: .isRequired,
        state: (if (.state | IN("PENDING", "EXPECTED")) then "PENDING"
                elif .state == "SUCCESS" then "PASS" else "FAIL" end),
        conclusion: .state, run_id: null, link: .targetUrl }
    end]) as $checks
| ([$pr.reviewThreads.nodes[] | select(.isResolved | not) |
    { thread_id: .id, path, line, outdated: .isOutdated,
      comments: [.comments.nodes[] | { id: .databaseId, author: .author.login, body, created_at: .createdAt, url }] }]) as $threads
| ([$pr.reviews.nodes[] | select(.author.login != $me)
    | select(.state == "CHANGES_REQUESTED" or ((.body // "") != "" and .submittedAt > $since))
    | { author: .author.login, state, body, submitted_at: .submittedAt, url }]) as $reviews
| ([$pr.comments.nodes[] | select(.author.login != $me) | select(.author.login | ci_bot | not)
    | select(.createdAt > $since)
    | { author: .author.login, body, created_at: .createdAt, url }]) as $comments
| ([$checks[] | select(.state == "FAIL")]) as $failing
| ([$checks[] | select(.state == "PENDING")]) as $pending
| ($pr.mergeable == "CONFLICTING" or $pr.mergeStateStatus == "DIRTY") as $conflicts
| ([ (if $conflicts then "conflicts" else empty end),
     (if ($failing | length) > 0 then "failing-checks" else empty end),
     (if ($threads | length) > 0 then "review-threads" else empty end),
     (if $pr.reviewDecision == "CHANGES_REQUESTED" then "changes-requested" else empty end),
     (if ($comments | length) > 0 then "new-comments" else empty end) ]) as $action
| ([ (if ($pending | length) > 0 then "checks-running" else empty end),
     (if $pr.reviewDecision == "REVIEW_REQUIRED" then "needs-approval" else empty end),
     (if $pr.mergeable == "UNKNOWN" then "mergeability-unknown" else empty end) ]) as $wait
| { verdict: (if $pr.state != "OPEN" then $pr.state
               elif ($action | length) > 0 then "ACTION"
               elif ($wait | length) > 0 then "WAITING"
               else "READY" end),
    reasons: (if ($action | length) > 0 then $action else $wait end),
    number: $pr.number, url: $pr.url, state: $pr.state, draft: $pr.isDraft,
    from_fork: $pr.isCrossRepository,
    head: $pr.headRefName, base: $pr.baseRefName, head_sha: $pr.headRefOid,
    head_committed_at: $since,
    merge_state: $pr.mergeStateStatus, mergeable: $pr.mergeable,
    review_decision: $pr.reviewDecision,
    failing_checks: $failing, pending_checks: ($pending | map(.name)),
    passing_checks: ([$checks[] | select(.state == "PASS")] | length),
    unresolved_threads: $threads, reviews: $reviews, new_comments: $comments }'

snapshot() {
  gh api graphql -f query="$query" -F owner="$owner" -F name="$name" -F number="$number" \
    | jq "$shape"
}

deadline=$(( $(date +%s) + wait_for ))
while :; do
  out=$(snapshot)
  verdict=$(printf '%s' "$out" | jq -r .verdict)
  if [ "$verdict" != "WAITING" ] || [ "$(date +%s)" -ge "$deadline" ]; then
    break
  fi
  sleep 30
done

printf '%s\n' "$out"
case "$verdict" in
  READY|MERGED|CLOSED) exit 0 ;;
  ACTION) exit 1 ;;
  *) exit 3 ;;
esac
