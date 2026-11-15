---
name: ace-audit-security
description: Audits the repository for High or Critical security vulnerabilities and files at most three tickets, or none.
disable-model-invocation: true
---

# Security auditor

Audit the repository for security vulnerabilities. File a ticket for each finding you keep. Done means at most three High or Critical tickets. Zero is a complete audit. Three is a cap, not a quota.

## Constraints

- Do not edit the repository. Do not apply a fix. Do not open a pull request. Do not write a file in the repo.
- File security vulnerabilities only. A logic bug with no exposure to an outsider or another user or tenant is out of scope.
- File only High or Critical. Do not file Low or Medium. Do not stretch a weaker finding to High so you have something to file.
- If nothing is High or Critical, stop. Open no tickets.

## Workflow

```
- [ ] 1. Scan
- [ ] 2. Drop ignored and known-risk findings
- [ ] 3. Check existing tickets
- [ ] 4. Cap at three High or Critical, or file none
- [ ] 5. File those
- [ ] 6. Stop
```

## 1. Scan

Read the code. Find:

- Exposed secrets
- XSS or other unescaped output
- Insecure API endpoints
- Server-side handlers with missing or weak auth
- Injection
- Path traversal
- SSRF or unsafe URL handling in server-side requests

Respect the trust boundaries the project's `ace/` files state. Do not file missing authorization between parties the project trusts.

A finding needs a concrete exposure. Do not file a hypothetical with no plausible impact, or an unverified dependency issue.

## 2. Drop ignored and known-risk findings

Ignore generated and vendored code, and any path the project's `ace/` files mark as out of scope.

If a High or Critical hole has no zero-cost fix, file it and write the cheapest correct fix. Do not file a weaker finding whose only fix adds runtime cost.

Never file an accepted risk.

## 3. Check existing tickets

For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches.

Skip a finding when a ticket already exists with the same root cause, primary files, or exposure.

## 4. Cap at three High or Critical, or file none

Rank what remains. Drop Low and Medium.

If none are High or Critical, file nothing. Do not file Medium or Low to fill the cap.

If one or two are, file those. Do not hunt for a third.

If more than three are, file the three most severe. Leave the rest unfiled.

Severity, highest first:

- **Critical.** A secret is exposed, or an outsider can read or change data of many users or tenants.
- **High.** An outsider, or another user or tenant, can read or change data or act through one endpoint or handler.
- **Medium.** A real hole that needs an extra condition, and it does not expose a secret or another user's data by itself. Do not file.
- **Low.** A real hole with little the attacker can do. Do not file.

On a tie, keep the wider exposure.

Map severity to Priority when you file. Critical is `Urgent`, High is `High`.

## 5. File those

Skip this step when step 4 kept none. One ticket per finding. A writeup in the session does not count. For each ticket, write the body with `ace-write-ticket`, then open it as `ace/TICKET_TRACKER.md` says.

Title starts with `Security: `. Type is `Bug`. Priority is the map in step 4. Choose Size from the concrete fix as `ace-write-ticket` defines it.

Who this is from is Security Auditor.

Goal is what the person using the product would have when this is fixed, in everyday words, with no code, file names, or internal terms.

Task is the concrete fix, with `path:lines`.

In Done when, include a test only for critical infrastructure: auth, tenant isolation, webhooks, stored data integrity, or secrets.

## 6. Stop

When the tickets exist, or when nothing was filed, stop.
