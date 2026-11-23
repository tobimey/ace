#!/usr/bin/env bash
# Prints the state of one GitHub pull request as JSON, with a verdict.
# Usage: pr-state.sh NUMBER [--repo OWNER/NAME] [--wait SECONDS] [--from-json FILE]
#   --wait       poll every 15 seconds while the verdict is WAITING, up to SECONDS (capped at 90).
#   --from-json  read a saved GraphQL response from FILE instead of calling gh.
# Needs gh (authenticated) and jq.
# Exit 0: READY, MERGED, or CLOSED. 1: ACTION. 3: WAITING. 2: bad input.
#
# Verdict:
#   ACTION   conflicts, a failing check, an unresolved review thread whose last
#            comment is not an Ace reply, or a review or comment newer than the
#            last answer: the head commit or the newest Ace reply, if later.
#            The latest "<!-- ace-review -->" report counts, whoever posted
#            it, when it holds findings and was edited after the last answer
#   WAITING  checks still running, a required review is missing, or a person
#            must answer an Ace reply (a thread or requested changes)
#   READY    nothing left for an agent; reason "draft" when a person must
#            still mark it ready
# An Ace reply is a comment whose body contains "<!-- ace-babysit".
set -euo pipefail

number=""
repo=""
wait_for=0
from_json=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --repo) repo="$2"; shift 2 ;;
    --wait) wait_for="$2"; shift 2 ;;
    --from-json) from_json="$2"; shift 2 ;;
    -h|--help) sed -n '2,/^set -euo/p' "$0" | sed '$d'; exit 0 ;;
    *) number="$1"; shift ;;
  esac
done

case "$number" in
  ''|*[!0-9]*) echo "usage: pr-state.sh NUMBER [--repo OWNER/NAME] [--wait SECONDS] [--from-json FILE]" >&2; exit 2 ;;
esac
[ -n "$repo" ] || [ -n "$from_json" ] || repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
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
        comments(last: 50) { nodes { databaseId author { __typename login } body createdAt updatedAt url } }
      } }
      reviews(last: 50) { nodes { author { __typename login } state body submittedAt url } }
      comments(last: 100) { nodes { author { __typename login } body createdAt updatedAt url } }
    }
  }
}'

shape='
def is_bot: (.author.__typename == "Bot") or ((.author.login // "") | test("\\[bot\\]$"));
def ace: (.body // "") | contains("<!-- ace-babysit");
def review_report: (.body // "") | contains("<!-- ace-review -->");
# A finding left in the report starts a line with its severity emoji, as ace-review/SKILL.md formats it.
def has_findings: (.body // "") | test("(^|\n)(🔴|🟡|🔵) \\*\\*");
.data.repository.pullRequest as $pr
| ($pr.commits.nodes[0].commit) as $head
| ([$head.committedDate]
   + [$pr.comments.nodes[] | select(ace) | .updatedAt]
   + [$pr.reviewThreads.nodes[].comments.nodes[] | select(ace) | .updatedAt]
   | max) as $since
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
| ([$pr.reviewThreads.nodes[] | select(.isResolved | not)]) as $open_threads
| ([$open_threads[] | select((.comments.nodes | last) // {} | ace | not) |
    { thread_id: .id, path, line, outdated: .isOutdated,
      comments: [.comments.nodes[] | { id: .databaseId, author: .author.login, body, created_at: .createdAt, url }] }]) as $threads
| ([$open_threads[] | select((.comments.nodes | last) // {} | ace)] | length) as $answered_threads
| ([$pr.reviews.nodes[]
    | select(.state == "CHANGES_REQUESTED" or (.body // "") != "")
    | select(.submittedAt > $since)
    | { author: .author.login, state, body, submitted_at: .submittedAt, url }]) as $reviews
| ([$pr.comments.nodes[] | select(review_report)] | sort_by(.updatedAt) | last) as $report
| ($report != null and ($report | has_findings) and $report.updatedAt > $since) as $report_new
| ([$pr.comments.nodes[] | select(ace | not) | select(review_report | not)
    | select(is_bot | not)
    | select(.createdAt > $since)
    | { author: (.author.login // "ghost"), body, created_at: .createdAt, url }]) as $comments
| ([$checks[] | select(.state == "FAIL")]) as $failing
| ([$checks[] | select(.state == "PENDING")]) as $pending
| ($pr.mergeable == "CONFLICTING" or $pr.mergeStateStatus == "DIRTY") as $conflicts
| ([ (if $conflicts then "conflicts" else empty end),
     (if ($failing | length) > 0 then "failing-checks" else empty end),
     (if ($threads | length) > 0 then "review-threads" else empty end),
     (if ($reviews | length) > 0 then "new-reviews" else empty end),
     (if ($comments | length) > 0 then "new-comments" else empty end),
     (if $report_new then "review-findings" else empty end) ]) as $action
| ([ (if ($pending | length) > 0 then "checks-running" else empty end),
     (if $pr.reviewDecision == "REVIEW_REQUIRED" then "needs-approval" else empty end),
     (if $answered_threads > 0 then "threads-answered" else empty end),
     (if $pr.reviewDecision == "CHANGES_REQUESTED" then "changes-requested-awaiting-reviewer" else empty end),
     (if $pr.mergeable == "UNKNOWN" then "mergeability-unknown" else empty end) ]) as $wait
| { verdict: (if $pr.state != "OPEN" then $pr.state
               elif ($action | length) > 0 then "ACTION"
               elif ($wait | length) > 0 then "WAITING"
               else "READY" end),
    reasons: (if ($action | length) > 0 then $action
              elif ($wait | length) > 0 then $wait
              elif $pr.isDraft then ["draft"]
              else [] end),
    number: $pr.number, url: $pr.url, state: $pr.state, draft: $pr.isDraft,
    from_fork: $pr.isCrossRepository,
    head: $pr.headRefName, base: $pr.baseRefName, head_sha: $pr.headRefOid,
    head_committed_at: $head.committedDate, answered_at: $since,
    merge_state: $pr.mergeStateStatus, mergeable: $pr.mergeable,
    review_decision: $pr.reviewDecision,
    failing_checks: $failing, pending_checks: ($pending | map(.name)),
    passing_checks: ([$checks[] | select(.state == "PASS")] | length),
    unresolved_threads: $threads, answered_threads: $answered_threads,
    reviews: $reviews, new_comments: $comments,
    review_report: (if $report then { url: $report.url, updated_at: $report.updatedAt,
                                      has_findings: ($report | has_findings), new: $report_new }
                    else null end) }'

snapshot() {
  if [ -n "$from_json" ]; then
    jq "$shape" "$from_json"
  else
    gh api graphql -f query="$query" -F owner="$owner" -F name="$name" -F number="$number" \
      | jq "$shape"
  fi
}

if [ "$wait_for" -gt 90 ]; then
  wait_for=90
fi

deadline=$(( $(date +%s) + wait_for ))
while :; do
  out=$(snapshot)
  verdict=$(printf '%s' "$out" | jq -r .verdict)
  if [ "$verdict" != "WAITING" ] || [ "$(date +%s)" -ge "$deadline" ]; then
    break
  fi
  sleep 15
done

printf '%s\n' "$out"
case "$verdict" in
  READY|MERGED|CLOSED) exit 0 ;;
  ACTION) exit 1 ;;
  *) exit 3 ;;
esac
