# Logic

Wrong behavior on a plausible input.

## Find

- Off-by-one or wrong bounds
- Impossible or unreachable branches
- Inverted conditions
- Incorrect async/await, or missing error handling that loses failures
- Wrong database or API assumptions
- Type or logic contradictions
- Stale cache, a wrong cache key, or invalidation that serves the wrong data
- User-visible or data-affecting incorrect behavior

## Belongs elsewhere

- An authorization hole, or wrong data that reaches another user or tenant through a bad cache key, is security.
- A cost with correct behavior is performance.

## Drop

- Concurrency, races, and missing locks or transactions, unless the impact is severe. Severe means money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong. Two tasks touching the same record is not a finding.
- A finding whose only fix adds runtime cost: extra database reads or writes, extra network, extra CPU on a request or task path, an N+1 query, or scanning more data. Keep a finding whose fix uses data already in memory. A severe race may use a transaction. For example, drop re-fetching a record on every request to work around a stale cache. When the change under review introduced that cost, write it as a performance finding instead.

## Severity

- **Critical.** Money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong.
- **High.** Wrong user-visible behavior on a common path, with stored data still correctable.
- **Medium.** Wrong behavior on a narrow path.
- **Low.** A real bug with a small, recoverable effect.

Ties go to the worse user impact.
