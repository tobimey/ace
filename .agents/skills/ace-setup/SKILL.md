---
name: ace-setup
description: Setup ace.
disable-model-invocation: true
---

# Ace Setup

Set up ace in this project. Done means the root agents file points at the adapters, and these adapters exist in the directory `ace` with no `<PLACEHOLDER>` left:

- `ace/GLOSSARY.md`: the project's shared terms
- `ace/CODING_STANDARDS.md`: what is out of scope, the trust boundaries, and the rules review and audit jobs check
- `ace/VERIFY.md`: the checks to run, how to run the app, and how to try a change
- `ace/TICKET_TRACKER.md`: how to read, search, open, and update a ticket, and how to link sub-tickets and blockers
- `ace/CODE_HOSTING.md`: how to get the diff to review, open a pull request, comment on one, and find the tickets a pull request closes

In a monorepo, each package the user picked also has `PACKAGE/ace/VERIFY.md`, and `PACKAGE/ace/CODING_STANDARDS.md` if it has its own rules. The root `ace/VERIFY.md` and `ace/CODING_STANDARDS.md` list them.

## Constraints

- An `ace` folder holds only adapters. Never move `AGENTS.md` or `CLAUDE.md` into it. Harnesses load them only from the repo root.
- Glossary, ticket tracker, and code hosting exist only at the root. A package never gets its own.
- If an adapter from the list above exists outside `ace`, such as a root `GLOSSARY.md`, move it there.
- Do not overwrite an existing file. Fill only what is missing.
- Do not guess a value. Look it up, or ask.
- Keep the section headings of the templates. Ace skills look them up by heading.

## 0. Detect the layout

Look for a workspace config at the repo root: `workspaces` in `package.json`, `pnpm-workspace.yaml`, `turbo.json`, `nx.json`, `lerna.json`, `rush.json`, `[workspace]` in `Cargo.toml`, `go.work`, or `include` in `settings.gradle`. Also count build manifests (`package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`, ...) below the root, outside vendored and generated paths.

If there is no workspace config and at most one manifest, it is a single repo. Skip the monorepo parts below.

Otherwise, list the packages from the workspace config, each with its path and whether it has its own checks (lint, test, build scripts) or its own app (a dev or start command). Show the list and ask:

- Is this a monorepo?
- Which packages get their own `ace` folder? Recommend one for each package with its own checks or its own app. A package left out uses the root files only.

## 1. Create the base files

The root agents file is `AGENTS.md` at the repo root. If only `CLAUDE.md` exists there, it is `CLAUDE.md`. If neither exists, create `AGENTS.md` from [templates/ROOT_AGENTS_FILE.md](templates/ROOT_AGENTS_FILE.md):

- `<PROJECT_SUMMARY>`: two or three sentences on what the project is and who it is for, from the README and package metadata. If they say nothing, ask.
- `<USER>`: who uses the product, such as "a developer using this library" or "a customer of the shop". Ask if unclear.

If `AGENTS.md` exists at the repo root and `CLAUDE.md` does not, create `CLAUDE.md` with this single line, so Claude Code loads `AGENTS.md` too:

```markdown
@AGENTS.md
```

If `ace/GLOSSARY.md` is missing, create it from [templates/GLOSSARY.md](templates/GLOSSARY.md):

- `<TERMS>`: up to five domain terms the README or docs define, one line each as `- **Term**: definition.` If none are defined, write `No terms yet.`

Both are drafts. Tell the user to read them and iterate.

Create `ace/CODING_STANDARDS.md` from [templates/CODING_STANDARDS.md](templates/CODING_STANDARDS.md) if it is missing. Then:

- `<TRUST_BOUNDARIES>`: ask which parties the project trusts, such as admins and the backend, or services inside the same network. Write `None.` if there are none.
- Ask which paths besides the defaults are out of scope, and add them.
- Show the default rules, tests, and smells. Remove the ones the user rejects.

In a monorepo, ask for each picked package whether it has rules of its own, such as React rules for a web app only. For each package that has some, create `PACKAGE/ace/CODING_STANDARDS.md` from [templates/PACKAGE_CODING_STANDARDS.md](templates/PACKAGE_CODING_STANDARDS.md), with `<PACKAGE>` as its name, `<PACKAGE_PATH>` as its path, and `<PACKAGE_RULES>` as one line per rule. Then add this section to the end of `ace/CODING_STANDARDS.md`, with one line per package file:

```markdown
## Packages

For a change in one of these paths, also read its file. It adds to this one, and this file wins on conflict.

- `apps/web/`: `apps/web/ace/CODING_STANDARDS.md`
```

## 2. Verification

Create `ace/VERIFY.md` from [templates/VERIFY.md](templates/VERIFY.md) if it is missing. In a monorepo, the root file holds only what applies to the whole repo, and each picked package gets its own `PACKAGE/ace/VERIFY.md` from the same template, filled for that package. Then:

- `<CHECK_COMMANDS>`: read the CI workflow and the build tool's scripts (`package.json`, `Makefile`, and so on). List one command each for lint, typecheck, tests, and build, plus any other check CI runs. Take a check from the local scripts when CI does not run it. When CI and the local scripts run the same check differently, use CI's command. Name each kind the project has no command for. Show the list and ask which to keep.
- `<RUN_APP>`: find the dev command, port, and environment setup in the scripts and docs. Ask for test logins, seed data, or setup you cannot find. Write `None.` when nothing runs, such as a library.
- `<CHECK_BEHAVIOR>`: ask how a person checks each kind of change the project has, such as a UI page, an API endpoint, a background job, or a CLI command. Offer the tools this environment has, such as browser automation or `curl`. Write one line per kind.

In a monorepo:

- A package's `<CHECK_COMMANDS>` run only that package, such as `pnpm --filter web test` or `cargo test -p api`. Use the filter CI uses. Run them from the repo root.
- The root `<CHECK_COMMANDS>` are the checks that cover the whole repo, such as a formatter over all files. If there are none, write `# No repo-wide checks.`
- The root `<RUN_APP>` says how to start everything at once, or `None.` The root `<CHECK_BEHAVIOR>` is `None.` unless a kind of change spans packages, such as an end-to-end test.

Then add this section to the end of `ace/VERIFY.md`, with one line per picked package:

```markdown
## Packages

For a change that touches one of these paths, also follow its file: run its checks, start its app, and try the behavior as it says.

- `apps/web/`: `apps/web/ace/VERIFY.md`
```

## 3. Ticket tracker

Ask which tracker holds the tickets (GitHub Issues, Linear, Jira, ...).

For GitHub Issues, start from [templates/TICKET_TRACKER.md](templates/TICKET_TRACKER.md). Fill each placeholder:

- `<ASSIGNEE>`: ask. Offer `gh api user --jq .login`.
- `<PROJECT_OWNER>`, `<PROJECT_NUMBER>`: `gh project list --owner OWNER`, then ask which one.
- `<ORG>`, `<PRIORITY_FIELD_ID>`, `<SIZE_FIELD_ID>`: the issue-fields lookup in the template.

If the repo has no project, or no Priority or Size field, ask whether to drop that part.

For another tracker, write the same sections with that tracker's CLI or API.

## 4. Code hosting

Ask which host holds the code (GitHub, GitLab, Bitbucket, ...).

For GitHub, start from [templates/CODE_HOSTING.md](templates/CODE_HOSTING.md). Fill each placeholder:

- `<DEFAULT_BRANCH>`: `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`.
- `<REPO>`: `gh repo view --json nameWithOwner --jq .nameWithOwner`.
- `<PR_TEMPLATE_PATH>`: the pull request template under `.github/`. If there is none, ask for the sections.
- `<PR_TEMPLATE_RULES>`: ask how each template section is filled. Remove the placeholder if there are no rules.

For another host, write the same sections with that host's CLI or API.

## 5. Point the root agents file at them

Add this section to the root agents file from step 1, if missing. Do not change anything else in that file.

```markdown
<!-- added by ace -->
## Ace

- Use the terms in `ace/GLOSSARY.md`.
- To verify a change, follow `ace/VERIFY.md`.
- To read, search, open, or update a ticket, follow `ace/TICKET_TRACKER.md`.
- To open or comment on a pull request, follow `ace/CODE_HOSTING.md`.
```

In a monorepo, add this line to that section:

```markdown
- A package with its own `ace` folder adds to the root files. The root `ace` files list which ones.
```
