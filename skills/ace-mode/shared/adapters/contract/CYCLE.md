# `ace/CYCLE.md`

Optional. It matters only when something other than a person starts runs, such as a CI job that a label starts or a cloud agent on a schedule. Ace writes no runner config: the user sets up the runner, and this file tells agents what it does.

| Section | What it holds | Used by |
|---|---|---|
| After Plan, After Build, After Review, After Audit | What the runner needs when that `ace-mode` playbook ends, such as setting a label or moving a ticket | `ace-mode` |
| Runs | Each trigger that starts an agent run without a person, and the message that run gets, or `None.` A message starts with `Runner: NAME.` when that runner has a section below. | `ace-mode`, the user |
| Runners | One subsection per runner, named as its messages name it. **Target**: where a run finds the pull request or ticket it works on, and what it does without one. **Limits**: such as branches it must not create, secrets, and what its token may do. Any section the runner does its own way, such as "Comment on a pull request" when `gh` there acts as a person. | [ADAPTERS.md](../ADAPTERS.md), in each run whose message names the runner |

**Default.** A person starts every run, and `ace-mode` names the next step from its Continue table. With no runner section, a run uses the adapters and providers as they are.
