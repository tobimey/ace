#!/usr/bin/env bash
# Tests pr-state.sh on saved GraphQL responses. Needs jq.
# Usage: tests/pr-state/run.sh
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
script="$here/../../skills/ace-adapters/github/pr-state.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

report_with_finding=$'<!-- ace-review -->\nModel: test-model\n\n🔴 **blocker** logic. The guard is inverted.\n\n**Best fix.** Swap the condition.\n\n`src/a.ts:4`'
report_clean=$'<!-- ace-review -->\nModel: test-model\n\nNo findings.'
ace_reply=$'<!-- ace-babysit -->\nModel: test-model\n\nFixed in def456.'

comment() { # AUTHOR BODY CREATED UPDATED
  jq -n --arg a "$1" --arg b "$2" --arg c "$3" --arg u "$4" \
    '{author: {login: $a}, body: $b, createdAt: $c, updatedAt: $u, url: "https://example.test/c"}'
}

failed=0
check() { # NAME EXPECTED_VERDICT EXPECTED_REASONS COMMENT_JSON...
  local name=$1 want_verdict=$2 want_reasons=$3
  shift 3
  local comments
  comments=$(printf '%s\n' "$@" | jq -s .)
  jq --argjson c "$comments" '.data.repository.pullRequest.comments.nodes = $c' \
    "$here/base.json" > "$tmp/case.json"
  local out got
  out=$("$script" 7 --from-json "$tmp/case.json" || true)
  got="$(printf '%s' "$out" | jq -r '.verdict + " " + (.reasons | join(","))')"
  if [ "$got" = "$want_verdict $want_reasons" ]; then
    echo "ok: $name"
  else
    echo "FAIL: $name: want '$want_verdict $want_reasons', got '$got'"
    failed=1
  fi
}

check "a review report a CI bot posted asks for action" ACTION review-findings \
  "$(comment 'github-actions[bot]' "$report_with_finding" 2026-11-01T11:00:00Z 2026-11-01T11:00:00Z)"

check "a review report edited after the last Ace reply asks for action" ACTION review-findings \
  "$(comment reviewer "$report_with_finding" 2026-11-01T11:00:00Z 2026-11-01T13:00:00Z)" \
  "$(comment dev "$ace_reply" 2026-11-01T12:00:00Z 2026-11-01T12:00:00Z)"

check "a review report with no findings is ready" READY "" \
  "$(comment reviewer "$report_clean" 2026-11-01T11:00:00Z 2026-11-01T11:00:00Z)"

check "a review report an Ace reply answered is ready" READY "" \
  "$(comment reviewer "$report_with_finding" 2026-11-01T11:00:00Z 2026-11-01T11:00:00Z)" \
  "$(comment dev "$ace_reply" 2026-11-01T12:00:00Z 2026-11-01T12:00:00Z)"

exit "$failed"
