# Ticket tracker

Tickets live in GitHub Issues. Every ace skill that reads, searches, opens, or updates a ticket follows this file. `OWNER/REPO` is `tobimey/ace`.

## Defaults

- Label: `agent-created` only.
- Assignee: `tobimey`.
- This repo has no GitHub project and no Priority or Size issue fields. Skip those.

## Constraints

- Open tickets here only. Do not open a ticket in any other tracker.
- Do not write a ticket body to a file in the repo. Pass it with `--body` and a heredoc.
- Do not put Priority or Size in the body or in a label.
- Do not delete a ticket if a later step fails.
- Set type with the API after create.

## Read a ticket

```bash
gh issue view NUMBER --comments
```

## Search tickets

```bash
gh search issues --repo "tobimey/ace" --match body --limit 30 --json number,title,body,state -- "TEXT"
```

## Open a ticket

The caller supplies title, body, type, Priority, and Size.

1. Once per run, ensure the label. If this prints nothing, run `gh label create agent-created`.

   ```bash
   gh label list --limit 200 --json name --jq '.[] | select(.name=="agent-created") | .name'
   ```

2. Create the ticket. The command prints the URL. Read the number from it.

   ```bash
   gh issue create --title "TITLE" --label agent-created --assignee tobimey --body "$(cat <<'EOF'
   BODY
   EOF
   )"
   ```

3. Confirm the label. The output must be `agent-created` and nothing else. If it is missing, run `gh issue edit NUMBER --add-label agent-created` and view again.

   ```bash
   gh issue view NUMBER --json labels --jq '.labels[].name'
   ```

4. Set type. Skip Priority and Size.
5. Skip adding to a project.

The ticket URL is the result. For another ticket in the same run, repeat from step 2.

## Update a ticket

```bash
gh issue edit NUMBER --title "TITLE" --add-label agent-created --add-assignee tobimey --body "$(cat <<'EOF'
BODY
EOF
)"
```

Do not remove other labels. Then set type. Skip Priority, Size, and the project.

## Set type, Priority, and Size

```bash
gh api --method PATCH "/repos/tobimey/ace/issues/NUMBER" -f type=TYPE
```

Replace `TYPE`. This repo has no Priority or Size issue fields. Do not post issue-field values.

If the type patch fails, keep the ticket.

## Add to the project

This repo has no GitHub project. Skip.

## Sub-tickets and blocking

The APIs take the ticket id, not its number.

```bash
CHILD_ID=$(gh api "/repos/tobimey/ace/issues/CHILD" --jq .id)
gh api --method POST "/repos/tobimey/ace/issues/PARENT/sub_issues" -F sub_issue_id="$CHILD_ID"

BLOCKER_ID=$(gh api "/repos/tobimey/ace/issues/BLOCKER" --jq .id)
gh api --method POST "/repos/tobimey/ace/issues/NUMBER/dependencies/blocked_by" -F issue_id="$BLOCKER_ID"
```
