---
name: ace-setup
description: Sets up Ace in a project with a quick setup, adds one module such as tickets or the cycle on request, or adds what an existing setup lacks after an Ace update.
disable-model-invocation: true
---

# Ace Setup

Set up Ace in this project. Ace works with no setup: every adapter section has a default, listed in [ADAPTERS.md](../ace-adapters/ADAPTERS.md). Setup replaces defaults with what this project does, one part at a time.

## Pick the run

- **No argument, and no `ace` folder**: the quick setup. Run steps 0, 1, 2, and 8. Done means the root agents file has the Ace section and a Glossary section, and `ace/VERIFY.md` exists with no `<PLACEHOLDER>` left and was followed once end to end.
- **A module name**: run that module's step, then step 8. Done means the module's files exist with no `<PLACEHOLDER>` left.
- **No argument, and an `ace` folder**: an update after an Ace update. Follow "Existing setup".

| Module | Step | Writes | Replaces the default for |
|---|---|---|---|
| `standards` | 3 | `ace/CODING_STANDARDS.md` | The template's rules and no trusted party |
| `tickets` | 4 | `ticket_tracker`, the ticket state labels, and `ace/TICKET_TRACKER.md` only for a tracker with no provider or for overrides | No ticket tracker |
| `hosting` | 5 | `ace/CODE_HOSTING.md`, only for a host with no provider or for pull request rules beyond the provider | The GitHub provider, or no pull requests off GitHub |
| `cycle` | 6 | `who_starts_runs` and `ace/CYCLE.md`, for a runner the user set up | A person starts every run |
| `settings` | 7 | `ace/config.json`, starting with `autonomy` | The defaults in [config.schema.json](config.schema.json) |

GitHub has built-in providers for tickets and code hosting in [ace-adapters/github/](../ace-adapters/github/). A module for GitHub sets a key in `ace/config.json` and writes no adapter file.

Ace writes no runner config, such as a CI workflow, and asks for no tokens or secrets. The user sets up any runner, and `ace/CYCLE.md` says what it does.

At the end of the quick setup, list the modules in one line each, with what the user gets from it, and recommend none until the user needs one.

In a monorepo, each package the user picked also gets `PACKAGE/ace/VERIFY.md`, and `PACKAGE/ace/CODING_STANDARDS.md` when the `standards` module runs and the package has its own rules. Skills find these folders by path, so no file lists them.

A step that could not run is named in the last reply.

## Constraints

- An `ace` folder holds only adapters, `config.json`, and the `adrs` folder. Keep `AGENTS.md` and `CLAUDE.md` at the repo root. Harnesses load them only from there.
- Glossary, ticket tracker, code hosting, and settings exist only at the root. Every package uses the root ones.
- If an adapter exists outside `ace`, such as a root `VERIFY.md`, move it there.
- Keep what existing files say. Add only what is missing: a whole adapter the run writes, or a section [ADAPTERS.md](../ace-adapters/ADAPTERS.md) lists that an existing adapter lacks.
- Write only the files of the run the user picked. A missing adapter is no error, since its defaults apply.
- Take every value from the repo or from the user. Look it up, or ask.
- Fill every section [ADAPTERS.md](../ace-adapters/ADAPTERS.md) lists for an adapter you write. Keep the template headings so the user can match them to that list. An adapter for a tool with a provider holds only the sections that differ from the provider.
- Never copy a provider into `ace/`. Ace updates it with each release.

## Existing setup

When the `ace` folder already holds adapters, this run brings them up to date after an Ace update. Create no adapter the user did not ask for. For each existing adapter, the package files included:

1. List the sections [ADAPTERS.md](../ace-adapters/ADAPTERS.md) names for it, and find each in the file by its job.
2. For each section the file lacks, copy it from the adapter's template, or from the step for that adapter when the template lacks it. Fill its placeholders as that step says. For a ticket tracker or code host other than GitHub, write the section with that tool, as steps 4 and 5 say. Skip this for an adapter whose provider is selected: the provider fills what the file lacks.
3. When you added a section to a verify file, follow "Prove it" for that file.

When `ace/config.json` exists, update it as step 7 says.

Run "Glossary" in step 1 and step 8 in every run. In the last reply, name each file and section you added, or say that nothing was missing.

## 0. Detect the layout

Look for a workspace config at the repo root: `workspaces` in `package.json`, `pnpm-workspace.yaml`, `turbo.json`, `nx.json`, `lerna.json`, `rush.json`, `[workspace]` in `Cargo.toml`, `go.work`, or `include` in `settings.gradle`. Also count build manifests (`package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`, ...) below the root, outside vendored and generated paths.

If there is no workspace config and at most one manifest, it is a single repo. Skip the monorepo parts below.

Otherwise, list the packages from the workspace config, each with its path and whether it has its own checks (lint, test, build scripts) or its own app (a dev or start command). Show the list and ask:

- Is this a monorepo?
- Which packages get their own `ace` folder? Recommend one for each package with its own checks or its own app. A package left out uses the root files only.

## 1. Root agents file

The root agents file is `AGENTS.md` at the repo root. If only `CLAUDE.md` exists there, it is `CLAUDE.md`. If neither exists, create `AGENTS.md` from [templates/ROOT_AGENTS_FILE.md](templates/ROOT_AGENTS_FILE.md):

- `<PROJECT_SUMMARY>`: two or three sentences on what the project is and who it is for, from the README and package metadata. If they say nothing, ask.
- `<USER>`: who uses the product, such as "a developer using this library" or "a customer of the shop". Ask if unclear.

If `AGENTS.md` exists at the repo root and `CLAUDE.md` does not, create `CLAUDE.md` with this single line, so Claude Code loads `AGENTS.md` too:

```markdown
@AGENTS.md
```

### Glossary

The glossary lives in the root agents file, so every session loads it. [ADAPTERS.md](../ace-adapters/ADAPTERS.md) describes its two tiers.

If the root agents file has no Glossary section, add the one from [templates/ROOT_AGENTS_FILE.md](templates/ROOT_AGENTS_FILE.md), marked `<!-- added by ace -->` on the line above it. If it has a glossary already, such as a list of who is who, add the lines it lacks there. Fill the placeholders:

- `<USER>`: as above.
- `<TERMS>`: up to five domain terms the README or docs define, one line each as `- **term**: definition. Not: other words for it.` Leave out `Not:` when no other word is in use. If no terms are defined, delete the line.

If a glossary file exists, such as a root `GLOSSARY.md` or `CONTEXT.md`, show the user this plan and wait for a yes:

1. Move each term's one-line definition into the Glossary section.
2. If the file has 40 terms or fewer, one meaning per word, and nothing beyond the one-line definitions, delete it.
3. Otherwise keep the rest as `ace/GLOSSARY.md`, without the one-line definitions, and end the Glossary section with ``More on these terms: `ace/GLOSSARY.md`.``

These are drafts. Tell the user to read them and iterate.

## 2. Verification

Create `ace/VERIFY.md` from [templates/VERIFY.md](templates/VERIFY.md) if it is missing. In a monorepo, the root file holds only what applies to the whole repo, and each picked package gets its own `PACKAGE/ace/VERIFY.md` from the same template, filled for that package. Find each value yourself:

- `<CHECK_COMMANDS>`: read the CI workflow and the build tool's scripts (`package.json`, `Makefile`, and so on). List one command each for lint, typecheck, tests, and build, plus any other check CI runs. Take a check from the local scripts when CI does not run it. When CI and the local scripts run the same check differently, use CI's command. Name each kind the project has no command for.
- `<RUN_APP>`: find the dev command, port, and environment setup in the scripts and docs. Write `None.` when nothing runs, such as a library.
- `<CHECK_BEHAVIOR>`: one line per kind of change the project has, such as a UI page, an API endpoint, a background job, or a CLI command, with the tool this environment has for it, such as browser automation or `curl`, where to start, such as a URL, an endpoint, or a command, and what to look at. When the project has a frontend, one line is for a UI change: browser automation, the URL of a page, and what to look at there.

Show the checks, how to run the app, and the behavior lines together, and ask once for a yes or corrections. In the same question, ask for test logins, seed data, or setup you could not find.

In a monorepo:

- A package's `<CHECK_COMMANDS>` run only that package, such as `pnpm --filter web test` or `cargo test -p api`. Use the filter CI uses. Run them from the repo root.
- The root `<CHECK_COMMANDS>` are the checks that cover the whole repo, such as a formatter over all files. If there are none, write `# No repo-wide checks.`
- The root `<RUN_APP>` says how to start everything at once, or `None.` The root `<CHECK_BEHAVIOR>` is `None.` unless a kind of change spans packages, such as an end-to-end test.

An agent runs the root checks and the package checks for a change in a package, so leave the root checks out of a package file.

### Prove it

Follow each verify file once, as an agent will, before you go on. In a monorepo, that is the root file and each package file.

1. Run every command in its "Checks" section.
2. Start the app as its "Run the app" section says, and wait until it is usable. Skip this and step 3 when the section says `None.`
3. Pick one line of its "Check behavior" section and one feature that exists today. Try that feature on the running app as the line says, and look at the result.
4. Stop every process you started.

When a step fails because the file is wrong, such as a wrong command, port, or start order, fix the file and run the steps again. When the same step fails after three fixes, ask the user. When a check fails because the code fails, keep the command, tell the user, and go on. Change no product code. When a step needs something only the user has, such as a login or a secret, ask for it. When they cannot give it, go on and name the step in your last reply.

## 3. Coding standards (`standards`)

Create `ace/CODING_STANDARDS.md` from [templates/CODING_STANDARDS.md](templates/CODING_STANDARDS.md) if it is missing. Then:

- `<TRUST_BOUNDARIES>`: ask which parties the project trusts, such as admins and the backend, or services inside the same network. Write `None.` if there are none.
- Ask which paths besides the defaults are out of scope, and add them.
- Show the default rules, tests, and smells. Remove the ones the user rejects.

In a monorepo, ask for each picked package whether it has rules of its own, such as React rules for a web app only. For each package that has some, create `PACKAGE/ace/CODING_STANDARDS.md` from [templates/PACKAGE_CODING_STANDARDS.md](templates/PACKAGE_CODING_STANDARDS.md), with `<PACKAGE>` as its name, `<PACKAGE_PATH>` as its path, and `<PACKAGE_RULES>` as one line per rule.

## 4. Ticket tracker (`tickets`)

Ask which tracker holds the tickets (GitHub Issues, Linear, Jira, ...).

For GitHub Issues:

1. Set `ticket_tracker` to `github-issues` in `ace/config.json`, creating the file as step 7 says when it is missing.
2. Create the ticket state labels: `gh label create ace:needs-dev`, `gh label create ace:ready`, and `gh label create ace:working`.
3. Ask whether new tickets get an assignee. Recommend none. On yes, offer `gh api user --jq .login`, and write `ace/TICKET_TRACKER.md` with a Defaults section that names the assignee.
4. Ask whether tickets should go into a GitHub project with Priority and Size fields. Recommend no: tickets work without them. On yes, add the section from [templates/GITHUB_PROJECT_FIELDS.md](templates/GITHUB_PROJECT_FIELDS.md) to `ace/TICKET_TRACKER.md`, creating the file from that template when it is missing. Fill it:
   - `<PROJECT_OWNER>`, `<PROJECT_NUMBER>`: `gh project list --owner OWNER`, then ask which one.
   - `<ORG>`, `<PRIORITY_FIELD_ID>`, `<SIZE_FIELD_ID>`: the issue-fields lookup in that section. When the org has no Priority or Size field, delete that part of the section.

For another tracker, set `ticket_tracker` to `custom`, and write `ace/TICKET_TRACKER.md` with every section [ADAPTERS.md](../ace-adapters/ADAPTERS.md) lists for the ticket tracker. Use the tracker's MCP server when the harness has one, otherwise its CLI or API. Use [the GitHub provider](../ace-adapters/github/TICKET_TRACKER.md) as the model.

## 5. Code hosting (`hosting`)

Ask which host holds the code (GitHub, GitLab, Bitbucket, ...).

For GitHub, Ace uses [its provider](../ace-adapters/github/CODE_HOSTING.md) with no setup. It fills the pull request template under `.github/`. Ask whether pull requests follow rules beyond that template, such as how a section is filled or which labels go on. On yes, write `ace/CODE_HOSTING.md` with an "Open a pull request" section that holds only those rules. Otherwise write nothing.

For another host, write `ace/CODE_HOSTING.md` with every section [ADAPTERS.md](../ace-adapters/ADAPTERS.md) lists for code hosting. Use the host's MCP server when the harness has one, otherwise its CLI or API. Use [the GitHub provider](../ace-adapters/github/CODE_HOSTING.md) as the model.

## 6. Cycle (`cycle`)

Ace writes no runner config. This step describes the runner the user set up, so `ace-mode` knows what starts the next run.

Ask whether anything other than a person starts agent runs, such as a CI job, a label, a schedule, or a cloud agent:

- **No**: a person starts every run, and `ace-mode` names the next step. Leave `who_starts_runs` at `person`, write no `ace/CYCLE.md`, and skip the rest of this step.
- **Yes**: set `who_starts_runs` to `custom`, and write `ace/CYCLE.md` with the sections [ADAPTERS.md](../ace-adapters/ADAPTERS.md) lists for it. Ask the user for each trigger. Write a hand-off only for a stage where the runner needs something, such as a label that starts a review.

Ask what the runner starts, and add a line to the Runs section of `ace/CYCLE.md` for each yes, with its trigger and its message:

- Reviews of pull requests, once per pull request, such as when it opens, since `ace-babysit-pr` pushes too. The message is `Review pull request #NUMBER and comment on it.`
- `ace-work-ticket`. It takes the next ticket a person set ready and opens a pull request for it. The message is `Run ace-work-ticket.` It needs a ticket tracker, so run step 4 first when the project has none. Ask for `autonomy` as step 7 says.
- Audits. Ask which domains. Each one's message is `Run ace-audit DOMAIN.`, such as `Run ace-audit security.` They file tickets, so they also need step 4.

Then tell the user what each run needs, and set none of it up:

- The Ace skills committed to the repo. Check that `.agents/skills/`, `.claude/skills/`, and `skills-lock.json` are tracked by git, each one that exists. If not, tell the user to commit them.
- The code host's CLI logged in where the agent runs, such as `gh` for GitHub, and the ticket tracker's when it has one. Ace reads and posts through them.
- Optional: `ACE_MODEL` set to the model id the run uses, so everything it posts names that model.
- For reviews, a model other than the one that implements the changes.

## 7. Settings (`settings`)

Settings say how much agents do on their own and which optional features are on. [config.schema.json](config.schema.json) defines each one, its values, and its default. A missing file or setting uses the default, as `ace-adapters` says.

When `ace/config.json` is missing, create it from [templates/config.json](templates/config.json). Replace `<SCHEMA>` with the path from `ace/` to `ace-setup/config.schema.json` in the installed Ace, so the schema matches the installed version: `../.agents/skills/ace-setup/config.schema.json` when that file exists, else `../.claude/skills/ace-setup/config.schema.json` when that one exists. Otherwise use the schema's `$id`. Set `ticket_tracker` and `who_starts_runs` as steps 4 and 6 found them. Then ask:

- `autonomy`: offer `low`, `medium`, and `high` with their meaning from the schema, and recommend `medium`. When the user picks `high` and a ready label starts `ace-work-ticket`, say that a ticket from an approved plan then goes to a pull request with no person in between. Say that `who_sets_ready` and `review.fixes` can each be set on their own and then win over `autonomy`. Write them only when the user asks.
- `write_adrs`: ask whether planning should record architecture decisions in `ace/adrs/`. Recommend `false` until decisions start getting lost.

Keep the default for every other setting, and name it in the last reply so the user knows it exists.

When `ace/config.json` exists, keep every value it has, and ask nothing. Add `ticket_tracker` and `who_starts_runs` when the file lacks them and the project uses a ticket tracker or a runner, as "Existing setup" says. Add no other missing setting, since a missing setting uses its default.

## 8. Point the root agents file at them

Add this section to the root agents file from step 1. If it is there already, add the lines it lacks. Leave the rest of that file as it is.

```markdown
<!-- added by ace -->
## Ace

- For every task, follow the `ace-mode` skill. It picks the Ace skills for the task and their order. When you reply without having loaded `ace-mode`, start the reply with `Ace not loaded:` and the reason.
- Ace reads project facts from the adapters in `ace/`, finding each section by its job, so its heading may differ. A missing file or section uses its default, as the `ace-adapters` skill next to `ace-mode` says.
- To verify a change, follow `ace/VERIFY.md`.
- Ace settings are in `ace/config.json`. A missing file or setting uses its default, as the `ace-adapters` skill says.
- Answer a question, a report, or an idea with an answer or a proposal, and leave the files as they are. Change files only when the message asks for a change: in words, such as "do it", "implement", "fix", or "add", by naming a job that changes files, such as `Review pull request #12` or a skill command, or by saying yes to a change you proposed. A skill then makes only the changes its Done names, within the settings in `ace/config.json`. When unsure, propose the change and ask.
- When a skill lists a skill under Requires whose folder is missing, tell the user to install Ace again with `npx skills add tobimey/ace`, which installs every skill.
```

Add each line below after the verify line: the ticket line when the project has a ticket tracker, from `ticket_tracker` or `ace/TICKET_TRACKER.md`, and the pull request line when the code is on GitHub or `ace/CODE_HOSTING.md` exists:

```markdown
- To read, search, open, or update a ticket, follow the ticket tracker, as the `ace-adapters` skill says.
- To open or comment on a pull request, follow the code hosting adapter, as the `ace-adapters` skill says.
```

In a monorepo, add this line to that section:

```markdown
- A package's `ace` folder adds to the root files for every path under it.
```
