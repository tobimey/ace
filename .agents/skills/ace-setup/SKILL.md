---
name: ace-setup
description: Sets up Ace in a project by creating its adapter files, or adds what an existing setup lacks after an Ace update.
disable-model-invocation: true
---

# Ace Setup

Set up ace in this project. Done means the root agents file turns on `ace-mode`, points at the adapters, and has a Glossary section with the project's shared terms, and these adapters exist in the directory `ace` with no `<PLACEHOLDER>` left:

- `ace/CODING_STANDARDS.md`: what is out of scope, the trust boundaries, and the rules review and audit jobs check
- `ace/VERIFY.md`: the checks to run, how to run the app, and how to try a change
- `ace/TICKET_TRACKER.md`: how to read, search, open, update, and comment on a ticket, how to link sub-tickets and blockers, and how the ticket states needs-dev, ready, and working show
- `ace/CODE_HOSTING.md`: how to get the diff to review, open a pull request, find or comment on one, and find the tickets a pull request closes
- `ace/CYCLE.md`, only when the user picked a runner in step 5: what a run does when a stage ends, and what starts a run without a person

In a monorepo, each package the user picked also has `PACKAGE/ace/VERIFY.md`, and `PACKAGE/ace/CODING_STANDARDS.md` if it has its own rules. The root `ace/VERIFY.md` and `ace/CODING_STANDARDS.md` list them.

Each verify file was also followed once end to end: its checks ran, the app started, and one behavior was tried and seen working. A step that could not run is named in the last reply.

## Constraints

- An `ace` folder holds only adapters. Keep `AGENTS.md` and `CLAUDE.md` at the repo root. Harnesses load them only from there.
- Glossary, ticket tracker, and code hosting exist only at the root. Every package uses the root ones.
- If an adapter from the list above exists outside `ace`, such as a root `VERIFY.md`, move it there.
- Keep what existing files say. Add only what is missing: a whole adapter, or a section [ADAPTERS.md](ADAPTERS.md) lists that an existing adapter lacks.
- Take every value from the repo or from the user. Look it up, or ask.
- Fill every section [ADAPTERS.md](ADAPTERS.md) lists. Ace skills depend on those sections and find each by its job. Keep the template headings so the user can match them to that list.

## Existing setup

When the `ace` folder already holds adapters, this run brings them up to date after an Ace update. Run steps 1 to 4 only for the adapters that are missing, and step 0 only when one of them is a verify or coding standards file. Then, for each existing adapter, the package files included:

1. List the sections [ADAPTERS.md](ADAPTERS.md) names for it, and find each in the file by its job.
2. For each section the file lacks, copy it from the adapter's template, or from the step for that adapter when the template lacks it, such as Packages. Fill its placeholders as that step says. For a ticket tracker or code host other than GitHub, write the section with that tool, as steps 3 and 4 say.
3. When you added a section to a verify file, follow "Prove it" for that file.

Run step 5 only when the user asks to add or change a runner, such as GitHub labels or a schedule. A missing `ace/CYCLE.md` means a person starts every run. When `ace/CYCLE.md` exists, its Runs section says `None.`, and each hand-off only tells the user the next step, it is the manual file an earlier Ace wrote. Offer to delete it, since `ace-mode` names the next step without it.

Run "Glossary" in step 1 and step 6 in every run. In the last reply, name each file and section you added, or say that nothing was missing.

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

### Glossary

The glossary lives in the root agents file, so every session loads it. [ADAPTERS.md](ADAPTERS.md) describes its two tiers.

If the root agents file has no Glossary section, add the one from [templates/ROOT_AGENTS_FILE.md](templates/ROOT_AGENTS_FILE.md), marked `<!-- added by ace -->` on the line above it. If it has a glossary already, such as a list of who is who, add the lines it lacks there. Fill the placeholders:

- `<USER>`: as above.
- `<TERMS>`: up to five domain terms the README or docs define, one line each as `- **term**: definition. Not: other words for it.` Leave out `Not:` when no other word is in use. If no terms are defined, delete the line.

If a glossary file exists, such as `ace/GLOSSARY.md` from an earlier Ace, a root `GLOSSARY.md`, or `CONTEXT.md`, show the user this plan and wait for a yes:

1. Move each term's one-line definition into the Glossary section.
2. If the file has 40 terms or fewer, one meaning per word, and nothing beyond the one-line definitions, delete it.
3. Otherwise keep the rest as `ace/GLOSSARY.md`, without the one-line definitions, and end the Glossary section with ``More on these terms: `ace/GLOSSARY.md`.``
4. Remove the line ``Use the terms in `ace/GLOSSARY.md`.`` from the Ace section of the root agents file.

These are drafts. Tell the user to read them and iterate.

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
- `<CHECK_BEHAVIOR>`: ask how a person checks each kind of change the project has, such as a UI page, an API endpoint, a background job, or a CLI command. Offer the tools this environment has, such as browser automation or `curl`. Write one line per kind with the tool, where to start, such as a URL, an endpoint, or a command, and what to look at.

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

Ask whether tickets should go into a GitHub project with Priority and Size fields. Recommend no: tickets work without them. On no, delete the "Project and fields" section. On yes, fill it:

- `<PROJECT_OWNER>`, `<PROJECT_NUMBER>`: `gh project list --owner OWNER`, then ask which one.
- `<ORG>`, `<PRIORITY_FIELD_ID>`, `<SIZE_FIELD_ID>`: the issue-fields lookup in that section. When the org has no Priority or Size field, delete that part of the section.

Create the ticket state labels: `gh label create ace:needs-dev`, `gh label create ace:ready`, and `gh label create ace:working`.

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

Ask how work should move from one stage to the next:

- **Manual** (recommend this to start): a person starts every run, and `ace-mode` names the next step. Write no `ace/CYCLE.md`, and skip the rest of this step.
- **GitHub labels**: adding the label `ace:review` to a pull request starts a review in GitHub Actions. Offer this only when the code is on GitHub.
- **Another runner**, such as a CI service or a cloud agent with a schedule: write `ace/CYCLE.md` with the sections [ADAPTERS.md](ADAPTERS.md) lists for it, using [templates/CYCLE_GITHUB_LABELS.md](templates/CYCLE_GITHUB_LABELS.md) as the model. Write a hand-off only for a stage where the runner does something, such as setting a label. Ask the user for each trigger.

For a runner, ask two more things, and add a line to the Runs section for each yes:

- Does `ace-work-ticket` run on a schedule? It takes the next ticket a person set ready and opens a pull request for it. Ask how often. Its message is `Run ace-work-ticket.`
- Do audits run on a schedule? Ask which domains and how often. Each one's message is `Run ace-audit DOMAIN.`, such as `Run ace-audit security.`

Set each one up on the user's runner. For GitHub labels, the steps below do it.

For GitHub labels:

1. Copy [templates/CYCLE_GITHUB_LABELS.md](templates/CYCLE_GITHUB_LABELS.md) with `<REPO>` from step 4.
2. Copy [templates/ace-review.yml](templates/ace-review.yml) to `.github/workflows/ace-review.yml`. Ask which harness and model run in CI. Recommend a model other than the one that implements the changes. Replace `<AGENT_STEP>` with the step that runs that harness without a person, from the harness's own CI docs. It uses the Ace skills committed in the repo and installs none, sets `GH_TOKEN: ${{ github.token }}` so the agent can push and comment, and sends this message: `Review pull request #${{ github.event.pull_request.number }}, fix what needs no decision, and comment on it.`
3. When `ace-work-ticket` runs on a schedule, copy [templates/ace-work-ticket.yml](templates/ace-work-ticket.yml) to `.github/workflows/ace-work-ticket.yml`. Replace `<CRON>` with the schedule, and `<AGENT_STEP>` with the same harness step, with `GH_TOKEN: ${{ secrets.ACE_GH_TOKEN }}` and the message `Run ace-work-ticket.` Ask which model implements. Otherwise delete its line in Runs.
4. When audits run on a schedule, copy [templates/ace-audit.yml](templates/ace-audit.yml) to `.github/workflows/ace-audit.yml`. Replace `<CRON>` with the schedule, `<DOMAINS>` with the domains as a JSON list in the order `ace-audit` runs them, such as `["security","logic"]`, and `<AGENT_STEP>` with the same harness step, with `GH_TOKEN: ${{ github.token }}` and the message `Run ace-audit ${{ matrix.domain }}.` Otherwise delete its line in Runs.
5. Fill `<WORK_CRON>`, `<AUDIT_CRON>`, and `<DOMAINS>` in `ace/CYCLE.md`.
6. Check that `.agents/skills/` and `skills-lock.json` are tracked by git. If not, tell the user to commit them, since the workflows run only on committed skills.
7. Name each secret the workflows need, and tell the user to add it to the repository: the harness's API key, and `ACE_GH_TOKEN` when `ace-work-ticket` runs. `ACE_GH_TOKEN` is a GitHub App token or a fine-grained personal access token with write access to contents, issues, and pull requests.
8. Create both labels: `gh label create ace:review --repo REPO` and `gh label create ace:reviewed --repo REPO`.

## 6. Point the root agents file at them

Add this section to the root agents file from step 1. If it is there already, add the lines it lacks. Leave the rest of that file as it is.

```markdown
<!-- added by ace -->
## Ace

- For every task, follow the `ace-mode` skill. It picks the Ace skills for the task and their order.
- To verify a change, follow `ace/VERIFY.md`.
- To read, search, open, or update a ticket, follow `ace/TICKET_TRACKER.md`.
- To open or comment on a pull request, follow `ace/CODE_HOSTING.md`.
- Answer a question, a report, or an idea with an answer or a proposal, and leave the files as they are. Change files only when the message asks for it, such as "do it", "implement", "fix", or "add". When unsure, propose the change and ask.
- Ace skills find an adapter section by its job, so its heading may differ. When a skill needs a file or a section that is missing, name it and say what it must hold. A skill that edits files offers to add it and goes on once the user agrees. Any other skill stops, unless it says what to do instead. With nobody to answer, or when the user declines, stop.
- When a skill lists a skill under Requires that is not installed, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.
```

In a monorepo, add this line to that section:

```markdown
- A package with its own `ace` folder adds to the root files. The root `ace` files list which ones.
```
