# `ace/CYCLE.md`

Optional. It matters only when something other than a person starts runs, such as a CI job that a label starts or a cloud agent on a schedule. Ace writes no runner config: the user sets up the runner, and this file tells agents what it does.

| Section | What it holds | Used by |
|---|---|---|
| After Plan, After Build, After Review, After Audit | What the runner needs when that `ace-mode` playbook ends, such as setting a label or moving a ticket | `ace-mode` |
| Runs | Each trigger that starts an agent run without a person, and the message that run gets, or `None.` | `ace-mode`, the user |

**Default.** A person starts every run, and `ace-mode` names the next step from its Continue table.
