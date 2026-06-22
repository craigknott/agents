Use this file for backend, distributed-system, queue, worker, async, migration, rollout, or operational changes. These
concerns matter even when they are not directly covered by tests.

# Reliability Checklist

Explicitly think through:

- Timeouts
- Retries and retry budgets
- Idempotency
- Concurrency and race conditions
- Backpressure and queue growth
- Partial failure behavior
- Logging, metrics, and tracing
- Rollout and migration safety
- Config, feature-flag, and environment impacts

# Async And Hot Paths

- Avoid blocking I/O, sleeps, or long-running work in async paths, event loops, request handlers, and hot loops.
- Preserve existing thread-safety, immutability, and lifecycle conventions.
- Avoid sharing mutable state across threads unless the project already has a safe established pattern.
- Before editing performance-sensitive code, inspect surrounding code for latency, throughput, and memory assumptions.

# Operational Changes

- Prefer idempotent migrations and jobs.
- Make partial failure behavior explicit when adding cross-service or queue-based work.
- Add observability when a new failure mode would otherwise be opaque.
- Call out rollout or environment assumptions in the final summary when they matter.
