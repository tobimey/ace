# Ticket tracker: GitHub Issues, write

Part of the built-in GitHub Issues tracker in [TICKET_TRACKER.md](../TICKET_TRACKER.md). A section in the project's `ace/TICKET_TRACKER.md` replaces the section here with the same job. `OWNER/REPO` is `gh repo view --json nameWithOwner --jq .nameWithOwner`.

## Defaults

- Labels: `ace-created` and `ace:needs-human`, plus `risk:high` when Risk is `High`.
- Assignee: none, unless `ace/TICKET_TRACKER.md` names one.
- Priority and Size: not recorded, unless `ace/TICKET_TRACKER.md` has a "Project and fields" section.

## Constraints

- Open tickets in this tracker only.
- Pass a ticket body with `--body` and a heredoc. Keep it out of files in the repo.
- Set Risk only as the `risk:high` label. Set Priority and Size only as the "Project and fields" section of `ace/TICKET_TRACKER.md` says, and leave them out when it does not exist.
- Never remove `ace-created`: it says Ace opened the ticket, not whose turn it is.
- Keep a ticket once it is created, even when a later step fails.
- Set type with the API after create.

## Open a ticket

The caller supplies title, body, type, and Risk, and may supply Priority and Size.

1. Once per run, ensure the labels. Create each one this prints as missing with `gh label create NAME`.

   ```bash
   have=$(gh label list --limit 200 --json name --jq '.[].name')
   for l in ace-created ace:needs-human risk:high; do echo "$have" | grep -qx "$l" || echo "missing: $l"; done
   ```

2. Create the ticket. Add `--label risk:high` when Risk is `High`. The command prints the URL. Read the number from it.

   ```bash
   gh issue create --title "TITLE" --label ace-created --label ace:needs-human --body "$(cat <<'EOF'
   BODY
   EOF
   )"
   ```

3. Confirm the labels. The output must be `ace-created` and `ace:needs-human`, plus `risk:high` when Risk is `High`, and nothing else. Add a missing one with `gh issue edit NUMBER --add-label NAME` and view again.

   ```bash
   gh issue view NUMBER --json labels --jq '.labels[].name'
   ```

4. Set the type as "Set the type" says.
5. Add the assignee with `gh issue edit NUMBER --add-assignee LOGIN` when `ace/TICKET_TRACKER.md` names one. When it has a "Project and fields" section, follow it.

The ticket URL is the result. For another ticket in the same run, repeat from step 2.

## Update a ticket

```bash
gh issue edit NUMBER --title "TITLE" --body "$(cat <<'EOF'
BODY
EOF
)"
```

Keep the other labels. Add `--add-label risk:high` when Risk is `High`, and `--remove-label risk:high` when it is `Low`. Then set the type, and follow the "Project and fields" section of `ace/TICKET_TRACKER.md` when it exists.

## Set the type

```bash
gh api --method PATCH "/repos/OWNER/REPO/issues/NUMBER" -f type=TYPE
```

Issue types exist only in repositories owned by an organization. If the call fails, keep the ticket and go on without a type.

## Sub-tickets and blocking

The APIs take the ticket id, not its number.

```bash
CHILD_ID=$(gh api "/repos/OWNER/REPO/issues/CHILD" --jq .id)
gh api --method POST "/repos/OWNER/REPO/issues/PARENT/sub_issues" -F sub_issue_id="$CHILD_ID"

BLOCKER_ID=$(gh api "/repos/OWNER/REPO/issues/BLOCKER" --jq .id)
gh api --method POST "/repos/OWNER/REPO/issues/NUMBER/dependencies/blocked_by" -F issue_id="$BLOCKER_ID"
```
