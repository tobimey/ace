# Ticket tracker: GitHub Issues, states

Part of the built-in GitHub Issues tracker in [TICKET_TRACKER.md](../TICKET_TRACKER.md). Its rules and `OWNER/REPO` apply here.

Keep at most one ticket state label on a ticket.

## Ticket states

Each state is a label.

- needs-human: `ace:needs-human`
- ready: `ace:ready`
- working: `ace:working`

## Set a ticket state

Swap the label of the old state for the label of the new one, then read the labels back:

```bash
gh issue edit NUMBER --remove-label FROM_LABEL --add-label TO_LABEL
gh issue view NUMBER --json labels --jq '.labels[].name'
```

## Comment on a ticket

```bash
gh issue comment NUMBER --body "$(cat <<'EOF'
TEXT
EOF
)"
```

To close it, as `completed` when the work is already done, else as `not planned`:

```bash
gh issue close NUMBER --reason REASON
```

## Find ready tickets

List the ready tickets, oldest first:

```bash
gh issue list --label ace:ready --state open --limit 50 \
  --json number,title,createdAt --jq 'sort_by(.createdAt) | .[] | "\(.number) \(.title)"'
```

Take them in that order. For each one, count its open blockers. The first ticket that prints `0` is the next ticket.

```bash
gh api "/repos/OWNER/REPO/issues/NUMBER/dependencies/blocked_by" --jq '[.[] | select(.state == "open")] | length'
```

## Find working tickets

```bash
gh issue list --label ace:working --state open --limit 50 \
  --json number,title --jq '.[] | "\(.number) \(.title)"'
```
