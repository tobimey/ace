# Security

A concrete exposure to an outsider, or to another user or tenant.

## Find

- Exposed secrets
- XSS or other unescaped output
- Insecure API endpoints
- Server-side handlers with missing or weak auth
- Injection
- Path traversal
- SSRF or unsafe URL handling in server-side requests

## Belongs elsewhere

A bug with no exposure to an outsider, or to another user or tenant, is logic.

## Drop

- Missing authorization between parties the coding standards list as trusted. Flag it only between parties the project does not trust.
- Unverified dependency advisories.
- A Medium or Low finding whose only fix adds runtime cost. When a Critical or High hole has no zero-cost fix, keep it with the cheapest correct fix.

## Severity

- **Critical.** A secret is exposed, or an outsider can read or change data of many users or tenants.
- **High.** An outsider, or another user or tenant, can read or change data or act through one endpoint or handler.
- **Medium.** A real hole that needs an extra condition, and does not expose a secret or another user's data by itself.
- **Low.** A real hole with little the attacker can do.

Ties go to the wider exposure.
