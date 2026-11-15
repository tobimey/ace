# Ticket tracker

Tickets live in GitHub Issues. Every ace skill that reads, searches, opens, or updates a ticket follows this file. `OWNER/REPO` is `gh repo view --json nameWithOwner --jq .nameWithOwner`.

## Defaults

- Labels: `agent-created` and `ace:needs-dev`, plus `risk:high` when Risk is `High`.
- Assignee: `<ASSIGNEE>`.
- Project: `<PROJECT_OWNER>` project `<PROJECT_NUMBER>`.
- Priority field id `<PRIORITY_FIELD_ID>`. Size field id `<SIZE_FIELD_ID>`. Both are org issue fields of `<ORG>`.

## Constraints

- Open tickets in this tracker only.
- Pass a ticket body with `--body` and a heredoc. Keep it out of files in the repo.
- Set Priority and Size only as fields. Set Risk only as the `risk:high` label.
- Keep at most one ticket state label on a ticket.
- Keep a ticket once it is created, even when a later step fails.
- Set type with the API after create.

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

## Open a ticket

The caller supplies title, body, type, Priority, Size, and Risk.

1. Once per run, ensure the labels. Create each one this prints as missing with `gh label create NAME`.

   ```bash
   have=$(gh label list --limit 200 --json name --jq '.[].name')
   for l in agent-created ace:needs-dev risk:high; do echo "$have" | grep -qx "$l" || echo "missing: $l"; done
   ```

2. Create the ticket. Add `--label risk:high` when Risk is `High`. The command prints the URL. Read the number from it.

   ```bash
   gh issue create --title "TITLE" --label agent-created --label ace:needs-dev --assignee <ASSIGNEE> --body "$(cat <<'EOF'
   BODY
   EOF
   )"
   ```

3. Confirm the labels. The output must be `agent-created` and `ace:needs-dev`, plus `risk:high` when Risk is `High`, and nothing else. Add a missing one with `gh issue edit NUMBER --add-label NAME` and view again.

   ```bash
   gh issue view NUMBER --json labels --jq '.labels[].name'
   ```

4. Set type, Priority, and Size.
5. Add to the project.

The ticket URL is the result. For another ticket in the same run, repeat from step 2.

## Update a ticket

```bash
gh issue edit NUMBER --title "TITLE" --add-label agent-created --add-assignee <ASSIGNEE> --body "$(cat <<'EOF'
BODY
EOF
)"
```

Keep the other labels. Add `--add-label risk:high` when Risk is `High`, and `--remove-label risk:high` when it is `Low`. Then set type, Priority, and Size, and add to the project.

## Set type, Priority, and Size

```bash
gh api --method PATCH "/repos/OWNER/REPO/issues/NUMBER" -f type=TYPE

gh api --method POST "/repos/OWNER/REPO/issues/NUMBER/issue-field-values" \
  --input - <<'EOF'
{"issue_field_values":[{"field_id":<PRIORITY_FIELD_ID>,"value":"High"},{"field_id":<SIZE_FIELD_ID>,"value":"M"}]}
EOF
```

Replace `TYPE` and both `value` strings. Use POST, which keeps the other fields.

If the field post returns 422, load the ids and post once more. Keep the ticket either way.

```bash
gh api "/orgs/<ORG>/issue-fields" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  --jq '.[] | select(.name=="Priority" or .name=="Size") | {id, name}'
```

## Add to the project

```bash
gh project item-add <PROJECT_NUMBER> --owner <PROJECT_OWNER> --url TICKET_URL
```

If this fails, keep the ticket.

## Sub-tickets and blocking

The APIs take the ticket id, not its number.

```bash
CHILD_ID=$(gh api "/repos/OWNER/REPO/issues/CHILD" --jq .id)
gh api --method POST "/repos/OWNER/REPO/issues/PARENT/sub_issues" -F sub_issue_id="$CHILD_ID"

BLOCKER_ID=$(gh api "/repos/OWNER/REPO/issues/BLOCKER" --jq .id)
gh api --method POST "/repos/OWNER/REPO/issues/NUMBER/dependencies/blocked_by" -F issue_id="$BLOCKER_ID"
```

## Ticket states

Each state is a label.

- needs-dev: `ace:needs-dev`
- ready: `ace:ready`
- working: `ace:working`

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
