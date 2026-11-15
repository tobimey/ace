---
name: ace-retro
description: Conducts a retrospective on a coding session and applies steering fixes for the problems it finds.
disable-model-invocation: true
---

# Retro

Find problems in the coding agent's environment from a session, then follow `ace-optimize-factory` for each one so the next run does not repeat them.

What done looks like: every problem from the session was given to `ace-optimize-factory`. Obvious steering fixes are applied. Remaining factory questions were asked in one round.

## Constraints

- Do not stop after listing candidates.
- Do not tell the user to run `ace-optimize-factory`. Follow it in this run.

## Steps

1. Read the primary sources for the session the user specifies. This may mean searching through session logs. If the user doesn't specify a session, default to the current one.

2. Look for candidates for improvement in these categories.

- **Navigation**: how easy was it for the agent to find the right files? Are there hidden dependencies between files? Would a **navigation pointer** make it easier? _Use when_ the session took a long time to find a piece of information.
- **Automated checks**: are there automated checks that could catch errors the agent made? Linting, typing, tests, filesystem linters? Read the repo's own check command first (its `package.json`/build-tool `lint`/`check` scripts, its CI workflow), so a check that already exists but sits unwired or silently broken is the finding, not a reinvention. A repo with no **guardrail** (no pre-commit hook and no CI job running its lint/typecheck/test command) is itself a finding: an un-linted repo is a standing missed opportunity, not a neutral default. _Use when_ the agent made a mistake an automated check could have caught, or the repo has no guardrail at all.
- **Coding standards**: should the **reviewer agent** be given a new rule to enforce? Should an existing rule be removed or clarified? Classify the violation first: a **mechanical** one (a fixed syntactic pattern, a banned API, an import shape, a file-location rule) gets a deterministic check, full stop: a custom rule in the repo's own linter, a new pre-commit hook, or a new CI job, whichever the repo's language and existing guardrail make cheapest. Default to building the check over writing the rule. Reserve the coding standards for genuine **judgement calls** (cross-file consistency, "matches the surrounding style," anything no guardrail could ever substitute for). _Use when_ the reviewer agent failed to catch a mistake.
- **Global AGENTS.md**: are there any steering instructions that should be moved to coding standards (or automated checks) instead? _Use when_ the AGENTS.md file is particularly large - in the repo OR the user's global scope.
- **Tool economy**: did the agent make expensive tool calls that could be streamlined? Is there any custom tooling (CLI's, MCP's) that is particularly token-inefficient? _Use when_ the agent made an expensive tool call.
- **No-ops**: look for instructions in steering files that don't modify the agent's behavior. _Use when_ the steering files are large and unwieldy.
- **Information access**: look for opportunities to increase the agent's access to information. Teeing dev server logs, readonly access to third-party services. _Use when_ a crucial piece of information was not available to the agent.

3. If there are no candidates, say so and stop. Otherwise, for each candidate, most severe first, follow `ace-optimize-factory` with that problem. Finish investigating every candidate and apply every obvious fix before asking. Ask every remaining factory question in one round.

## Reference

### Implementation vs Review

Remember that all work goes through two stages: implementation and review. The implementation agent has the most **context pressure**. They are responsible for exploration, writing code, and debugging failures.

The review agent has the least context pressure. It receives a diff, so no exploration is needed. `ace-implement` still checks the coding standards on the files it just changed and fixes behavior-identical breaks before it commits. `ace-validate-standards` commits whatever safe standards fixes remain. `ace-review` commits a fix when one edit is the correct one, and leaves the rest as findings.

### Files

You have access to several files in the repo:

- `AGENTS.md`: these files are pushed to the context window of any agent working in this repo. They should be used incredibly sparingly, usually only for **navigation pointers** to other files.
- Coding standards: `ace-implement` and `ace-validate-standards` both read this. Add **navigation pointers** to docs folders if the standards file gets more than 1,000 lines long.
- Docs: use docs as reference files, pointed to by other files. Look for existing docs before writing new ones.
- Skills: use skills for procedures (since their description goes into the agent's context window), or for user-invoked commands.
