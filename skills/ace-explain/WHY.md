# Why

Find out why the code is the way it is, from the record, not from the code. The code shows what was built. The record shows what the authors meant. Done means the user knows the reasons that were written down, which parts are your inference, and what nobody wrote down.

## Constraints

- Read only.
- Cite each reason: commit hash, pull request, ticket, or doc, and quote the author where you can.
- Mark every inference of your own as an inference. Present only what the record says as a stated reason.
- "The record does not say" is a valid answer. Say it instead of filling the gap.
- When an adapter section is missing, skip that source and name it in the output.

## Steps

1. Find the code the question is about.
2. Walk its history. Find the commit that introduced it and each later commit that changed its behavior, for example with `git log -S`, `git log -L`, and `git blame`. Skip formatting and move-only commits.
3. Read the discussion behind each commit that matters:
   - Pull requests: follow `ace/CODE_HOSTING.md`, including its "Linked tickets" section.
   - Tickets: follow the "Read a ticket" and "Search tickets" sections of `ace/TICKET_TRACKER.md`.
   - ADRs in `ace/adrs/`. An ADR that covers the code is the strongest stated reason.
   - Other docs the repo keeps, such as specs and the glossary.
4. If the trail is thin, look wider: code comments, tests named after a bug, the changelog.
5. If the user asks whether the reason still holds, check the reason against the code and its callers now.

**Output:** the answer first. Then the evidence, oldest first, with citations. Then your inferences, marked as such. Then what the record does not answer.
