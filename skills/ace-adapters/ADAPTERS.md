# Adapter contract

The adapters in `ace/`, and the glossary in the root agents file, belong to the project. Change them freely. Ace skills depend only on the sections each contract file below lists. Each section does the job named there. Its heading may differ, since skills find a section by its job. Everything else in an adapter is free.

For the ticket tracker, Ace ships a built-in provider for GitHub Issues in [github/](github/). A provider fills every section of its adapter, and the project selects it in `ace/config.json` instead of copying it. A file in `ace/` is needed only for a tool without a provider, or to replace single sections of one. Pull requests have no adapter: Ace supports them only on GitHub, as [github/PULL_REQUESTS.md](github/PULL_REQUESTS.md) says.

Every section has a default, in its contract file. A skill uses it when neither the file nor a provider has the section, as [SKILL.md](SKILL.md) says. `ace-setup` selects a provider or writes an adapter to replace the defaults with what this project does.

| Contract | Covers |
|---|---|
| [contract/GLOSSARY.md](contract/GLOSSARY.md) | The glossary in the root agents file, and `ace/GLOSSARY.md` |
| [contract/CODING_STANDARDS.md](contract/CODING_STANDARDS.md) | `ace/CODING_STANDARDS.md` |
| [contract/CHECKS.md](contract/CHECKS.md) | `ace/checks/` |
| [contract/VERIFY.md](contract/VERIFY.md) | `ace/VERIFY.md` |
| [contract/TICKET_TRACKER.md](contract/TICKET_TRACKER.md) | `ace/TICKET_TRACKER.md`, and the ticket states |
| [contract/PRODUCT.md](contract/PRODUCT.md) | `ace/PRODUCT.md` |
| [contract/CYCLE.md](contract/CYCLE.md) | `ace/CYCLE.md` |
| [contract/PACKAGES.md](contract/PACKAGES.md) | Package `ace` folders in a monorepo |

## `ace/config.json`

Settings, not an adapter. An adapter says how this project does a job. A setting says how much agents do on their own, and which optional features are on. [config.schema.json](../ace-setup/config.schema.json) defines each setting, its values, and its default. A skill reads a setting as [SKILL.md](SKILL.md) says, so a missing file or setting is no error.

| Setting | Used by |
|---|---|
| `autonomy` | Every skill that reads `who_sets_ready` or `review.fixes`, for their value when the key is missing |
| `ticket_tracker` | Every skill that reads `ace/TICKET_TRACKER.md`, to pick the provider |
| `who_starts_runs` | `ace-setup`, which writes `ace/CYCLE.md` when it is `custom` |
| `who_sets_ready` | `ace-to-ticket`, `ace-audit`, `ace-work-ticket` |
| `review` | `ace-review` |
| `write_adrs` | `ace-grill` |
| `max_tickets_per_audit_domain` | `ace-audit` |

## `ace/adrs/`

Optional. One file per architecture decision, from `ace-grill` when `write_adrs` is `true`. `ace-explain` reads them for why questions. `ace-implement` marks one `Superseded` when a plan replaces it.
