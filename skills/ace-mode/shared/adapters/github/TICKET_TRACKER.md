# Ticket tracker: GitHub Issues

The built-in ticket tracker for GitHub Issues. Ace uses it when `ticket_tracker` in `ace/config.json` is `github-issues`. A section in the project's `ace/TICKET_TRACKER.md` replaces the section with the same job here or in the files below, so a project overrides only what it does differently. `OWNER/REPO` is `gh repo view --json nameWithOwner --jq .nameWithOwner`.

This file holds the sections that read. The others are in their own files. Read only the one you need:

- "Defaults", "Open a ticket", "Update a ticket", "Set the type", and "Sub-tickets and blocking": [ticket-tracker/WRITE.md](ticket-tracker/WRITE.md)
- "Ticket states", "Set a ticket state", "Comment on a ticket", "Find ready tickets", and "Find working tickets": [ticket-tracker/STATES.md](ticket-tracker/STATES.md)

## Ticket references

A ticket is `#NUMBER`. A commit or pull request names the ticket it closes as `Closes #NUMBER` or `Fixes #NUMBER`. A bare `#NUMBER` may also be a pull request, so read it before you count it as a ticket.

## Read a ticket

```bash
gh issue view NUMBER --comments
```

## Search tickets

```bash
gh search issues --repo "OWNER/REPO" --match body --limit 30 --json number,title,body,state -- "TEXT"
```
