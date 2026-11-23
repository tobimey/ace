# Settings module (`settings`)

Configures `ace/config.json`, one decision per turn. All keys, values, and defaults come from [config.schema.json](config.schema.json).

## Interactive setup (creating or customizing `ace/config.json`)

When updating an existing `ace/config.json` from [UPDATE.md](UPDATE.md), skip the questions and follow "Silent schema update" below. Otherwise walk through Steps 1 to 4:

### Step 1 of 4 · Autonomy level

```markdown
### 🤖 Step 1 of 4 · Autonomy level

**Why:** Controls how much Ace acts on its own during reviews, ticket readiness, and rejected tickets.

**❓ 1 - How much autonomy should Ace have?**

- **A)** `low`: You set every ticket ready, reviews fix nothing automatically, and rejected tickets wait for you.
- **B)** `medium` (default): Reviews automatically fix issues with one clearly right fix; tickets still wait for you.
- **C)** `high`: Approved plan tickets go ready automatically, reviews pick reasonable fixes, and invalid tickets get closed automatically (audit tickets still wait for you).

➡️ **B)** Safe balance: fixes obvious review issues while keeping you in charge of ticket flow.
```

When the user picks `high` and a ready label triggers `ace-work-ticket`, add one note that tickets from an approved plan will then go straight to a pull request with no person in between.

### Step 2 of 4 · Communication style

```markdown
### 💬 Step 2 of 4 · Communication style

**Why:** Controls whether Ace speaks in code details or plain product behavior in chat replies and pull request explainers.

**❓ 1 - How should Ace talk to you?**

- **A)** `code` (default): Refer to files, lines, symbols, and code as needed.
- **B)** `product`: Speak in user-facing behavior and flows, leaving out file paths, code snippets, and stack traces unless asked.

➡️ **A)** Best if you read and write code; pick **B** for non-code workflows.
```

### Step 3 of 4 · Architecture decision records

```markdown
### 📐 Step 3 of 4 · Architecture decision records (ADRs)

**Why:** Decides whether planning saves hard-to-reverse technical decisions as short notes in `ace/adrs/`.

**❓ 1 - Record architecture decisions in `ace/adrs/`?**

- **A)** `false` (default): Skip ADRs for now.
- **B)** `true`: Save an ADR whenever planning settles a hard-to-reverse trade-off.

➡️ **A)** Turn it on later once design decisions start getting lost.
```

### Step 4 of 4 · Review & save

Resolve `<SCHEMA>`: use `../.agents/skills/ace-setup/config.schema.json` if that file exists, else `../.claude/skills/ace-setup/config.schema.json` if that exists, else the `$id` from [config.schema.json](config.schema.json). Keep any existing `ticket_tracker` value.

```markdown
### ✅ Step 4 of 4 · Save settings

**Why:** Writes your preferences to `ace/config.json`. Any omitted setting uses its default automatically.

**Summary:**
- **autonomy:** `<value>`
- **communication:** `<value>`
- **write_adrs:** `<value>`
- **Other default kept:** `review.require_other_model: false` (set to `true` later to require a different model for reviews)
- **File:** `ace/config.json`

**❓ 1 - Save these settings?**

- **A)** Yes, save `ace/config.json`
- **B)** Change a setting first

➡️ **A)** You can edit `ace/config.json` anytime with schema autocomplete.
```

On confirm: write `ace/config.json` from [templates/config.json](templates/config.json) with the confirmed values and `<SCHEMA>`, then print a one-line `🎉 Settings saved!` (or advance to the next module in `full`).

## Silent schema update (called from `UPDATE.md`)

When `ace/config.json` already exists during an existing-setup update:

1. Keep every value whose key is still in [config.schema.json](config.schema.json).
2. Remove keys no longer listed in the schema and note each removed key in the summary.
3. Add `"ticket_tracker": "github-issues"` if missing and the project uses GitHub Issues.
4. Leave all other missing settings absent so their defaults apply.
