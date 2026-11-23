# Standards module (`standards`)

Configures `ace/CODING_STANDARDS.md` (and optional package standards in a monorepo), one decision per turn. Read [templates/CODING_STANDARDS.md](templates/CODING_STANDARDS.md) silently first. Total steps: 4 (5 in a monorepo with package `ace/` folders).

## Step 1 · Trust boundaries

```markdown
### 🛡️ Step 1 of <N> · Trust boundaries

**Why:** Tells reviews and audits which users or internal services are already trusted, so Ace skips false security warnings between them.

**❓ 1 - Which parties does this project trust?**

- **A)** None (treat every caller as untrusted)
- **B)** Specific parties (name them, such as admins, backend services, or internal network)

➡️ **A)** Start strict and add trusted parties only where you mean to trust them.
```

## Step 2 · Out-of-scope paths & accepted risks

```markdown
### 🚧 Step 2 of <N> · Skipped paths & accepted risks

**Why:** Keeps reviews and audits focused by skipping noise folders and ignoring known risks your team has already accepted.

**Defaults already skipped:** Generated code, vendored code, lockfiles.

**❓ 1 - Add extra skipped paths or accepted risks?**

- **A)** Keep defaults only (no extra paths or accepted risks)
- **B)** Add paths or accepted risks (list them)

➡️ **A)** You can add exceptions anytime as they come up.
```

## Step 3 · Starter coding rules

Summarize the Rules, Tests, and Smells from [templates/CODING_STANDARDS.md](templates/CODING_STANDARDS.md) in short readable bullets (keeping the whole message scannable):

```markdown
### 📏 Step 3 of <N> · Starter coding rules

**Why:** Reviews and audits check your code against these rules alongside your linter and type checker.

**Starter rules:**
- **Rules:** <compact 1-line summary of the 6 rules>
- **Tests:** <compact 1-line summary of the 3 test rules>
- **Smells:** <compact 1-line summary of the 5 code smells>

**❓ 1 - Keep these starter rules?**

- **A)** Keep all of them
- **B)** Remove or add specific rules (tell me which)

➡️ **A)** They cover common agent mistakes without duplicating a linter.
```

## Step 4 (monorepo only) · Package-specific rules

When the repo is a monorepo with package `ace/` folders, ask:

```markdown
### 📦 Step 4 of 5 · Package-specific rules

**Why:** Lets a package add rules that only apply there (such as React rules for a web app) while keeping root rules as the tie-breaker.

**Packages:** `<package list>`

**❓ 1 - Do any packages need their own rules?**

- **A)** No, root coding standards cover all packages
- **B)** Yes (name the package and its rules)

➡️ **A)** Add package rules only when a package has stack-specific conventions.
```

## Final step · Review & save

```markdown
### ✅ Step <N> of <N> · Save coding standards

**Why:** Writes your confirmed coding standards so future reviews and audits follow them.

**Summary:**
- **Trust boundaries:** <value or "None">
- **Extra skipped paths / accepted risks:** <value or "Defaults only">
- **Rules:** <"All starter rules" or short list of changes>
- **Files:** `ace/CODING_STANDARDS.md` <plus any `PACKAGE/ace/CODING_STANDARDS.md`>

**❓ 1 - Save coding standards?**

- **A)** Yes, save
- **B)** Change something first

➡️ **A)** You can edit `ace/CODING_STANDARDS.md` anytime.
```

On confirm: create `ace/CODING_STANDARDS.md` from [templates/CODING_STANDARDS.md](templates/CODING_STANDARDS.md) with the confirmed values (adding `## Accepted risks` when provided, removing rejected rules). For each monorepo package with custom rules, create `PACKAGE/ace/CODING_STANDARDS.md` from [templates/PACKAGE_CODING_STANDARDS.md](templates/PACKAGE_CODING_STANDARDS.md) filling `<PACKAGE>`, `<PACKAGE_PATH>`, and `<PACKAGE_RULES>`. End with a one-line `🎉 Coding standards saved!` (or advance to the next module in `full`).
