#!/usr/bin/env sh
# Lists wording that steering text must replace.
# Usage: scripts/check-wording.sh <file-or-folder>...
# Scans Markdown files only.
# Exit 0 when nothing is found, 1 when lines are listed.
#
# EM DASH: replace with a period or a comma.
# NEGATION: rewrite as the action to take. Keep the line only when the
# negation states a fact or a condition, not an order.

if [ "$#" -eq 0 ]; then
  echo "usage: $0 <file-or-folder>..." >&2
  exit 2
fi

found=0
emdash=$(printf '\342\200\224')

if grep -rnI --include="*.md" "$emdash" "$@" | sed 's/^/EM DASH: /' | grep .; then
  found=1
fi

if grep -rnIiE --include="*.md" "(^|[^a-z])(do not|don't|never|avoid|should not|shouldn't|must not|mustn't)([^a-z]|$)" "$@" \
  | sed 's/^/NEGATION: /' | grep .; then
  found=1
fi

exit "$found"
