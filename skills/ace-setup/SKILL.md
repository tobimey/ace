---
name: ace-setup
description: Sets up Ace in a project by creating its adapter files.
disable-model-invocation: true
---

# Ace Setup

Set up ace in this project. Done means the root agents file turns on `ace-mode` and points at the adapters, and these adapters exist in the directory `ace` with no `<PLACEHOLDER>` left:

- `ace/GLOSSARY.md`: the project's shared terms
- `ace/CODING_STANDARDS.md`: what is out of scope, the trust boundaries, and the rules review and audit jobs check
- `ace/VERIFY.md`: the checks to run, how to run the app, and how to try a change
- `ace/TICKET_TRACKER.md`: how to read, search, open, and update a ticket, and how to link sub-tickets and blockers
- `ace/CODE_HOSTING.md`: how to get the diff to review, open a pull request, find or comment on one, and find the tickets a pull request closes
- `ace/CYCLE.md`: what happens when a stage ends, and what starts a run without a person

In a monorepo, each package the user picked also has `PACKAGE/ace/VERIFY.md`, and `PACKAGE/ace/CODING_STANDARDS.md` if it has its own rules. The root `ace/VERIFY.md` and `ace/CODING_STANDARDS.md` list them.

Each verify file was also followed once end to end: its checks ran, the app started, and one behavior was tried and seen working. A step that could not run is named in the last reply.

## Constraints

- An `ace` folder holds only adapters. Keep `AGENTS.md` and `CLAUDE.md` at the repo root. Harnesses load them only from there.
- Glossary, ticket tracker, and code hosting exist only at the root. Every package uses the root ones.
- If an adapter from the list above exists outside `ace`, such as a root `GLOSSARY.md`, move it there.
- Keep existing files as they are. Fill only what is missing.
- Take every value from the repo or from the user. Look it up, or ask.
- Fill every section [ADAPTERS.md](ADAPTERS.md) lists. Ace skills depend on those sections and find each by its job. Keep the template headings so the user can match them to that list.

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

### Prove it

Follow each verify file once, as an agent will, before you go on. In a monorepo, that is the root file and each package file.

1. Run every command in its "Checks" section.
2. Start the app as its "Run the app" section says, and wait until it is usable. Skip this and step 3 when the section says `None.`
3. Pick one line of its "Check behavior" section and one feature that exists today. Try that feature on the running app as the line says, and look at the result.
4. Stop every process you started.

When a step fails because the file is wrong, such as a wrong command, port, or start order, fix the file and run the steps again. When the same step fails after three fixes, ask the user. When a check fails because the code fails, keep the command, tell the user, and go on. Change no product code. When a step needs something only the user has, such as a login or a secret, ask for it. When they cannot give it, go on and name the step in your last reply.

## 3. Ticket tracker

Ask which tracker holds the tickets (GitHub Issues, Linear, Jira, ...).

For GitHub Issues, start from [templates/TICKET_TRACKER.md](templates/TICKET_TRACKER.md). Fill each placeholder:

- `<ASSIGNEE>`: ask. Offer `gh api user --jq .login`.
- `<PROJECT_OWNER>`, `<PROJECT_NUMBER>`: `gh project list --owner OWNER`, then ask which one.
- `<ORG>`, `<PRIORITY_FIELD_ID>`, `<SIZE_FIELD_ID>`: the issue-fields lookup in the template.

If the repo has no project, or no Priority or Size field, ask whether to drop that part.

For another tracker, write every section [ADAPTERS.md](ADAPTERS.md) lists for the ticket tracker. Use the tracker's MCP server when the harness has one, otherwise its CLI or API. Use the GitHub template as the model.

## 4. Code hosting

Ask which host holds the code (GitHub, GitLab, Bitbucket, ...).

For GitHub, start from [templates/CODE_HOSTING.md](templates/CODE_HOSTING.md). Fill each placeholder:

- `<DEFAULT_BRANCH>`: `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`.
- `<REPO>`: `gh repo view --json nameWithOwner --jq .nameWithOwner`.
- `<PR_TEMPLATE_PATH>`: the pull request template under `.github/`. If there is none, ask for the sections.
- `<PR_TEMPLATE_RULES>`: ask how each template section is filled. Remove the placeholder if there are no rules.

For another host, write every section [ADAPTERS.md](ADAPTERS.md) lists for code hosting. Use the host's MCP server when the harness has one, otherwise its CLI or API. Use the GitHub template as the model.

## 5. Cycle

Create `ace/CYCLE.md` if it is missing. Ask how work should move from one stage to the next:

- **Manual** (recommend this to start): a person starts every run, and `ace-mode` names the next step. Copy [templates/CYCLE.md](templates/CYCLE.md).
- **GitHub labels**: adding the label `ace:review` to a pull request starts a review in GitHub Actions. Offer this only when the code is on GitHub.
- **Another runner**, such as a CI service or a cloud agent with a schedule: start from the manual template, then write each hand-off and each run with that runner's trigger. Ask the user for each one.

For GitHub labels:

1. Copy [templates/CYCLE_GITHUB_LABELS.md](templates/CYCLE_GITHUB_LABELS.md) with `<REPO>` from step 4.
2. Copy [templates/ace-review.yml](templates/ace-review.yml) to `.github/workflows/ace-review.yml`. Ask which harness runs in CI. Replace `<AGENT_STEP>` with the step that runs that harness without a person, from the harness's own CI docs. It installs the Ace skills, sets `GH_TOKEN: ${{ github.token }}` so the agent can push and comment, and sends this message: `Review pull request #${{ github.event.pull_request.number }}, fix what needs no decision, and comment on it.`
3. Name the secret the harness needs, such as an API key, and tell the user to add it to the repository.
4. Create both labels: `gh label create ace:review --repo REPO` and `gh label create ace:reviewed --repo REPO`.

Then ask whether audits run on a schedule. For each one the user wants, add the trigger to the Runs section, with the message the run gets, such as `Run ace-audit-security.`, and set it up on the user's runner.

## 6. Point the root agents file at them

Add this section to the root agents file from step 1. If it is there already, add the lines it lacks. Leave the rest of that file as it is.

```markdown
<!-- added by ace -->
## Ace

- For every task, follow the `ace-mode` skill. It picks the Ace skills for the task and their order.
- Use the terms in `ace/GLOSSARY.md`.
- To verify a change, follow `ace/VERIFY.md`.
- To read, search, open, or update a ticket, follow `ace/TICKET_TRACKER.md`.
- To open or comment on a pull request, follow `ace/CODE_HOSTING.md`.
- Answer a question, a report, or an idea with an answer or a proposal, and leave the files as they are. Change files only when the message asks for it, such as "do it", "implement", "fix", or "add". When unsure, propose the change and ask.
```

In a monorepo, add this line to that section:

```markdown
- A package with its own `ace` folder adds to the root files. The root `ace` files list which ones.
```
