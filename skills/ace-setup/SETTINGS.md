# Settings module (`settings`)

Configures `ace/config.json`, one decision per turn. All keys, values, and defaults come from [config.schema.json](config.schema.json).

## Step 1 of 4 · 🤖 Autonomy level

- **Why:** Controls how much Ace acts on its own during reviews, ticket readiness, and rejected tickets.
- **Question:** How much autonomy should Ace have? **A)** `low`: You set every ticket ready, reviews fix nothing automatically, and rejected tickets wait for you. · **B)** `medium` (default): Reviews automatically fix issues with one clearly right fix; tickets still wait for you. · **C)** `high`: Approved plan tickets go ready automatically, reviews pick reasonable fixes, and invalid tickets get closed automatically (audit tickets still wait for you).
- **Recommend:** **B)** Safe balance: fixes obvious review issues while keeping you in charge of ticket flow.
- **On C:** when a ready label triggers `ace-work-ticket`, add one note that tickets from an approved plan will then go straight to a pull request with no person in between.

## Step 2 of 4 · 💬 Communication style

- **Why:** Controls whether Ace speaks in code details or plain product behavior in chat replies and pull request explainers.
- **Question:** How should Ace talk to you? **A)** `code` (default): Refer to files, lines, symbols, and code as needed. · **B)** `product`: Speak in user-facing behavior and flows, leaving out file paths, code snippets, and stack traces unless asked.
- **Recommend:** **A)** Best if you read and write code; pick **B** for non-code workflows.

## Step 3 of 4 · 📐 Architecture decision records (ADRs)

- **Why:** Decides whether planning saves hard-to-reverse technical decisions as short notes in `ace/adrs/`.
- **Question:** Record architecture decisions in `ace/adrs/`? **A)** `false` (default): Skip ADRs for now. · **B)** `true`: Save an ADR whenever planning settles a hard-to-reverse trade-off.
- **Recommend:** **A)** Turn it on later once design decisions start getting lost.

## Step 4 of 4 · ✅ Save settings

Resolve `<SCHEMA>`: use `../.agents/skills/ace-setup/config.schema.json` if that file exists, else `../.claude/skills/ace-setup/config.schema.json` if that exists, else the `$id` from [config.schema.json](config.schema.json). Keep any existing `ticket_tracker` value.

- **Why:** Writes your preferences to `ace/config.json`. Any omitted setting uses its default automatically.
- **Summary:** **autonomy:** `<value>` · **communication:** `<value>` · **write_adrs:** `<value>` · **Other default kept:** `review.require_other_model: false` (set to `true` later to require a different model for reviews) · **File:** `ace/config.json`
- **Question:** Save these settings? **A)** Yes, save `ace/config.json` · **B)** Change a setting first
- **Recommend:** **A)** You can edit `ace/config.json` anytime with schema autocomplete.
- **On confirm:** write `ace/config.json` from [templates/config.json](templates/config.json) with the confirmed values and `<SCHEMA>`, then print a one-line `🎉 Settings saved!` (or advance to the next module in `full`).
