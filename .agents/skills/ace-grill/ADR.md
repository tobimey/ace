# ADR

An ADR records one decision, so a later reader knows why the code is the way it is. Write one only for a decision that is all three:

- **Hard to reverse.** Changing it later costs real work, such as a data shape, a public contract, or a dependency many modules use.
- **Surprising without context.** A capable newcomer would ask "why not the obvious way?"
- **A real trade-off.** You weighed at least two options, and each had a cost.

A decision that misses one of these stays in the summary and the ticket.

## File

`ace/adrs/NNNN-kebab-case-title.md`. `NNNN` is the next free number, four digits, starting at `0001`. Create `ace/adrs/` with the first ADR.

```markdown
# NNNN. Title

Status: Accepted
Date: YYYY-MM-DD

## Context

What forced the decision, in a few sentences.

## Decision

What we chose, stated as a fact.

## Options

- **Chosen option**: why it won.
- **Other option**: why it lost.

## Consequences

What gets easier, what gets harder, and what would make us revisit this.
```

When a new ADR replaces an earlier one, set the earlier one's Status to `Superseded by NNNN`, and leave the rest of it as it is.
