#!/usr/bin/env bash
# Human-in-the-loop reproduction loop.
# Adapted from mattpocock/skills (MIT), diagnosing-bugs/scripts/hitl-loop.template.sh.
#
# Copy this file outside the repository, replace the steps between the
# markers, and ask the user to run it in their own terminal:
#
#   bash hitl-loop.sh
#
# Helpers:
#   step "<instruction>"        shows an instruction and waits for Enter
#   capture VAR "<question>"    shows a question and reads the answer into VAR
#
# The script ends by printing the captured values as KEY=VALUE lines.
# The user pastes that Captured block back to the agent.
#
# capture echoes its answer to the terminal. Use it for observations, and
# leave signing in to the user as a step.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter when done] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- edit below ---------------------------------------------------------

step "Open the app and sign in."

capture ERRORED "Click the button that triggers the bug. Did it fail? (y/n)"

capture ERROR_MSG "Paste the error message, or 'none':"

# --- edit above ---------------------------------------------------------

printf '\n--- Captured ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
