# `ace/checks/`

Optional. One file per custom check, such as `ace/checks/ACCESSIBILITY.md`, for an area the project wants checked with its own severity. Single rules belong in `ace/CODING_STANDARDS.md`. `ace-review` runs each file as its own check through its [CUSTOM.md](../../../../ace-review/CUSTOM.md), `ace-audit` as its own domain through its [CUSTOM.md](../../../../ace-audit/CUSTOM.md), and `ace-garden` as a topic when asked. The check's name is the file name in lower case, without `.md`. Pick a name no built-in check or audit domain uses, such as `security` or `code`.

| Section | What it holds | Default |
|---|---|---|
| Find | What counts as a finding | Required |
| Drop | What to leave out even when found | Required |
| Severity | What makes a finding Critical, High, Medium, or Low | Required |
| Before scanning | What to read first | Nothing |
| Belongs elsewhere | What another check owns | Coding standards go to Standards, and logic, security, performance, and architecture go to Code. |
| Bar | Which findings an audit files | Only Critical and High |
| Ticket | How an audit ticket looks | Title starts with the check's name, type `Chore` |

**Default.** No folder, no custom checks. Only the root has one, also in a monorepo. `ace-setup` ships [templates/CHECK.md](../../../../ace-setup/templates/CHECK.md) to copy.
