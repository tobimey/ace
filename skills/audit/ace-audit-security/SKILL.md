---
name: ace-audit-security
description: Audits the repository for High or Critical security holes and files at most three tickets, or none.
disable-model-invocation: true
---

# Security auditor

Load `ace-audit` and follow it. This skill sets the domain: security holes.

## Find

- Exposed secrets
- XSS or other unescaped output
- Insecure API endpoints
- Server-side handlers with missing or weak auth
- Injection
- Path traversal
- SSRF or unsafe URL handling in server-side requests

A logic bug with no exposure to an outsider, or to another user or tenant, belongs to `ace-audit-logic`.

## Drop

A weaker finding whose only fix adds runtime cost. When a Critical or High hole has no zero-cost fix, file it with the cheapest correct fix.

## Bar

Highest first. File only Critical and High. Ties go to the wider exposure.

- **Critical.** A secret is exposed, or an outsider can read or change data of many users or tenants.
- **High.** An outsider, or another user or tenant, can read or change data or act through one endpoint or handler.
- **Medium.** A real hole that needs an extra condition, and does not expose a secret or another user's data by itself.
- **Low.** A real hole with little the attacker can do.

## Ticket

Title starts with `Security: `. Type is `Bug`. Who this is from is Security Auditor.
