# Code check

Logic bugs, security holes, performance costs, and architecture.

## Before scanning

Load [ace-checks](../ace-checks/SKILL.md) and read its Logic, Security, Performance, and Architecture files. Read the call sites the change affects, not only the moved lines.

## Find

In the diff and the call sites it affects, find what each `ace-checks` file's Find section lists. Follow the Framework behavior section of the Performance file. File a finding under the domain its Belongs elsewhere section names.

For architecture, flag the concrete better shape, and propose a redesign only for files this diff changes.

## Drop

Apply the Drop section of each `ace-checks` file. Drop anything that is only style, naming, folder placement, or "the spec didn't ask for this". Leave out unverified dependency advisories.

If a logic bug's only fix is extra runtime cost, write it as a performance finding when this diff introduced the cost, and drop it otherwise.

## Belongs elsewhere

Coding standards, naming, and code smells belong to [Standards](STANDARDS.md). Spec match belongs to [Spec](SPEC.md).

## Severity

Rate each finding by the Severity section of its `ace-checks` file, then write that level as:

- `blocker`: Critical, or High outside architecture.
- `should-fix`: Medium, or High architecture.
- `nit`: Low.

## Fix type

Every architecture finding is `needs-a-person`. For logic, security, and performance, use the fix types of the Finding section in [SKILL.md](SKILL.md).

**Example (`one-correct-fix`).** An inverted condition sends the message to the wrong user. Swap the condition.

**Example (`several-fixes`).** The same read could move to a background job or stay on the request.
