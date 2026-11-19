# Performance

Runtime cost on a real path.

## Framework behavior

Judge caching, data loading, and rendering from the docs of the main framework's installed version. Use the docs the installed package ships, or else the docs for that version. Read a page only when a candidate finding needs it.

## Find

- Waterfalls: independent awaits or requests that run one after the other on a request path
- N+1 queries, or one network call per item in a loop
- Extra database reads or writes on a request or background-job path
- A shared, expensive read with no cache, or a direct read that bypasses a cached helper the codebase already has for that data. The fix is to call the cached helper.
- Per-user or per-request data stored in a shared cache, bloating memory
- Data loaded on the client that the server could load, or more data sent to the client than the path uses
- Work on a hot path that could run in the background
- Scanning or loading more data than the path needs
- A slow part that blocks the whole page or response when it could load on its own

## Belongs elsewhere

Wrong data from a bad cache key is logic, or security when it reaches another user or tenant.

## Drop

- Micro-optimizations, and one-off costs on a rare path with no plausible wait.
- What the framework or compiler already optimizes.
- Reads required for correctness.
- A change that splits a shared cache into many smaller ones.
- Dependent awaits. Two awaits where the second needs the first's id are not a waterfall.

## Severity

- **Critical.** A common path shows nothing until a chain of independent reads finishes, or a shared cache stores per-user data at scale.
- **High.** A waterfall, N+1, or blocked response on a common path.
- **Medium.** Extra cost on a narrower path, or a wrong cache lifetime or invalidation.
- **Low.** A real cost with a small local fix.

Ties go to the longer user wait.
