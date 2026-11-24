# Comments

Comments rot faster than code and let hacks hide behind an excuse. Keep only comments that carry an external constraint or non-obvious invariant that names, types, or tests cannot express.

## Before scanning

Read the Rules section of the coding standards.

## Find

- Tautology: repeats what the code already shows, or narrates obvious steps.
- Stale: refers to behavior, symbols, or workarounds that no longer exist.
- Excuse: justifies a hack, workaround, or unjustified lint or type suppression (such as `eslint-disable` or `@ts-ignore`) instead of fixing the cause.
- Encodable constraint: states a rule (such as "keep in sync" or "call after init") that a name, type, assertion, or test can enforce instead.
- Decision record: explains a hard-to-reverse architectural trade-off that belongs in an ADR rather than inline.

## Drop

- External constraints the codebase cannot change, such as vendor quirks, protocol limits, or legal headers.
- Public API doc comments when the project's coding standards or linter require them.
- Lint or type suppressions backed by a verified external constraint.

## Fix

Clean one file (or one tightly linked cluster) per run:

1. Delete tautological and stale comments.
2. For an excuse comment or unjustified suppression, fix the underlying hack when the fix is small and keeps behavior unchanged, then delete the comment or suppression. Otherwise leave the comment in place and report the hack as a candidate.
3. For an encodable constraint, encode it in a name, type, or test and delete the comment.
4. For a decision record, move it into an ADR in `ace/adrs/` (following [ADR.md](../ace-grill/ADR.md)) when `write_adrs` in `ace/config.json` is `true`, then delete the comment. Otherwise keep only the shortest note that names the trade-off.
