# Ticket tracker

Tickets live in GitHub Issues, as `ticket_tracker` in `ace/config.json` says. Ace follows its built-in GitHub Issues tracker. The sections below add to it or replace its section with the same job.

## Project and fields

Priority field id `<PRIORITY_FIELD_ID>`. Size field id `<SIZE_FIELD_ID>`. Both are org issue fields of `<ORG>`. Project: `<PROJECT_OWNER>` project `<PROJECT_NUMBER>`.

Set Priority and Size, when the caller supplied them:

```bash
gh api --method POST "/repos/OWNER/REPO/issues/NUMBER/issue-field-values" \
  --input - <<'EOF'
{"issue_field_values":[{"field_id":<PRIORITY_FIELD_ID>,"value":"High"},{"field_id":<SIZE_FIELD_ID>,"value":"M"}]}
EOF
```

Replace both `value` strings. Use POST, which keeps the other fields.

If the field post returns 422, load the ids and post once more. Keep the ticket either way.

```bash
gh api "/orgs/<ORG>/issue-fields" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  --jq '.[] | select(.name=="Priority" or .name=="Size") | {id, name}'
```

Add the ticket to the project:

```bash
gh project item-add <PROJECT_NUMBER> --owner <PROJECT_OWNER> --url TICKET_URL
```

If this fails, keep the ticket.
