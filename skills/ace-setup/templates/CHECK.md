# <CHECK_NAME>

<WHAT_IT_COVERS>

`ace-review` runs this file as its own check on every change, `ace-audit` runs it as its own domain over the whole repository, and `ace-garden` fixes one finding per run when asked. Findings use the file name as their category. Keep single rules in `ace/CODING_STANDARDS.md`.

## Find

What counts as a finding, one line each.

- <FINDING>

## Drop

What to leave out even when found.

- <DROP>

## Severity

How bad each kind of finding is. Review maps Critical and High to `blocker`, Medium to `should-fix`, and Low to `nit`.

- **Critical.** <CRITICAL>
- **High.** <HIGH>
- **Medium.** <MEDIUM>
- **Low.** <LOW>

<!-- Optional sections:
## Before scanning   What to read first, such as a guideline or a list of screens.
## Belongs elsewhere What another check owns, such as logic or security.
## Bar               Which findings an audit files. Default: only Critical and High.
## Ticket            How an audit ticket looks. Default: title starts with the check's name, type Chore.
Say "Every finding needs a person." anywhere in the file to keep review from fixing its findings. -->
