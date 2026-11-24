# Watch mode

Loaded by [SKILL.md](SKILL.md) only when `ace-babysit-pr` runs in `watch` mode.

1. Read the state again with `--wait` for every pull request that got a push or has checks running, for up to about ten minutes per pass.
2. Run step 3 of [SKILL.md](SKILL.md) on each pull request with verdict `ACTION`.
3. Repeat until no pull request got a push or has checks running, or after ten passes.
4. A pull request waiting only for a reviewer's approval, untrusted comments, or a person to answer your reply leaves the watch as waiting.
5. Write to the user only when a pass changed something or stopped.
