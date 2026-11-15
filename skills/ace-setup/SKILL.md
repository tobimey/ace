---
name: ace-setup
description: Setup ace.
disable-model-invocation: true
---

# Ace Setup

Set up ace in this project. Done means these files exist in the directory `ace`, and the ticket tracker and code hosting files have no `<PLACEHOLDER>` left:

- `ace/GLOSSARY.md`
- `ace/AGENTS.md`
- `ace/CODING_STANDARDS.md`
- `ace/TICKET_TRACKER.md`: how to read, search, open, and update a ticket, and how to link sub-tickets and blockers
- `ace/CODE_HOSTING.md`: how to open a pull request, how to comment on one, and how to find the tickets a pull request closes

## Constraints

- If a file exists outside `ace`, move it there. Do not overwrite an existing file. Fill only what is missing.
- Do not guess a value. Look it up, or ask.
- Keep the section headings of the templates. Ace skills look them up by heading.

## 1. Create the base files

Create `ace/GLOSSARY.md`, `ace/AGENTS.md`, and `ace/CODING_STANDARDS.md` if they are missing.

## 2. Ticket tracker

Ask which tracker holds the tickets (GitHub Issues, Linear, Jira, ...).

For GitHub Issues, start from [templates/TICKET_TRACKER.md](templates/TICKET_TRACKER.md). Fill each placeholder:

- `<ASSIGNEE>`: ask. Offer `gh api user --jq .login`.
- `<PROJECT_OWNER>`, `<PROJECT_NUMBER>`: `gh project list --owner OWNER`, then ask which one.
- `<ORG>`, `<PRIORITY_FIELD_ID>`, `<SIZE_FIELD_ID>`: the issue-fields lookup in the template.

If the repo has no project, or no Priority or Size field, ask whether to drop that part.

For another tracker, write the same sections with that tracker's CLI or API.

## 3. Code hosting

Ask which host holds the code (GitHub, GitLab, Bitbucket, ...).

For GitHub, start from [templates/CODE_HOSTING.md](templates/CODE_HOSTING.md). Fill each placeholder:

- `<DEFAULT_BRANCH>`: `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`.
- `<REPO>`: `gh repo view --json nameWithOwner --jq .nameWithOwner`.
- `<PR_TEMPLATE_PATH>`: the pull request template under `.github/`. If there is none, ask for the sections.
- `<PR_TEMPLATE_RULES>`: ask how each template section is filled. Remove the placeholder if there are no rules.

For another host, write the same sections with that host's CLI or API.

## 4. Point AGENTS.md at them

Add to `ace/AGENTS.md`, if missing:

```markdown
- To read, search, open, or update a ticket, follow `ace/TICKET_TRACKER.md`.
- To open or comment on a pull request, follow `ace/CODE_HOSTING.md`.
```
