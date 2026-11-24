# `ace/checks/`

Optional. One file per custom check, such as `ace/checks/ACCESSIBILITY.md`, for an area the project wants checked with its own severity. Single rules belong in `ace/CODING_STANDARDS.md`. `ace-review` runs each file as its own check, `ace-audit` as its own domain, and `ace-garden` as a topic when asked. Each uses the defaults below for a section the file lacks. The check's name is the file name in lower case, without `.md`. Pick a name no built-in check, audit domain, or garden topic uses, such as `security`, `code`, or `naming`.

| Section | What it holds | Default |
|---|---|---|
| Find | What counts as a finding | Required |
| Drop | What to leave out even when found | Required |
| Severity | What makes a finding Critical, High, Medium, or Low | Required |
| Before scanning | What to read first | Nothing |
| Belongs elsewhere | What another check owns | Coding standards go to Standards, and logic, security, performance, and architecture go to Code. |
| Bar | Which findings an audit files | Only Critical and High, highest first. Ties go to the smaller safe fix. |
| Ticket | How an audit ticket looks | Title starts with the check's name and `: `, such as `Accessibility: `. Type is `Chore`. Who this is from is the check's name plus Auditor, such as Accessibility Auditor. |

**Default.** No folder, no custom checks. Only the root has one, also in a monorepo. `ace-setup` ships [templates/CHECK.md](../../../../ace-setup/templates/CHECK.md) to copy.
