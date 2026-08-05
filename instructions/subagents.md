Use before delegating work to subagents or parallel agent threads.

## Permission Boundary

- Subagents are opt-in. Delegate only when the user or an applicable workflow explicitly requests subagents, delegation,
  or parallel agent work.
- Do not infer permission from task size alone. Without opt-in, the primary agent owns the work.
- Do not spawn nested children unless the root agent explicitly authorizes it.

## Balanced Use

Once delegation is permitted, use it when at least one of these conditions applies:

- Two or more independent, bounded workstreams can make useful progress concurrently.
- A specialized exploration, documentation, large-file scan, review, or verification track materially improves quality
  or reduces risk.
- Context isolation keeps a large investigation from obscuring the primary agent's integration work.

Do not delegate work that is sequential, trivial, tightly coupled to the primary agent's next decision, faster to do
locally than to explain, or likely to duplicate another agent's investigation. Do not fill concurrency slots merely
because they are available.

When parallel work is explicitly requested and independent workstreams exist, assign enough agents to cover those
workstreams within the available capacity. Keep the primary agent working on the critical path, integration, or another
non-overlapping task instead of waiting unnecessarily.

## Scope and Integration

- Give each child a self-contained task capsule with the objective, exact scope, relevant decisions, constraints,
  deliverable, and verification requirements.
- Assign non-overlapping responsibilities and, for implementation, non-overlapping file ownership whenever practical.
  Do not ask multiple agents to perform the same scan or edit the same files unless an independent comparison is the
  explicit purpose.
- Default to the smallest useful context. Use `fork_turns="none"`; use `"2"` only when the latest clarification or
  failure is essential, and `"all"` only when the complete decision history is indispensable.
- Require concise summaries with file references and relevant failing lines, not raw logs or exploration transcripts.
- The primary agent owns user intent, skill selection and instruction reading, integration, conflict resolution, final
  validation, and completion. Treat child output as evidence to verify, not as automatically accepted work.
- Delegation does not reduce the completion standard in `instructions/workflow.md`.

## Routing

Use these defaults when the active tool exposes the corresponding roles and model controls:

| Task | Role | Model and effort | `fork_turns` |
| --- | --- | --- | --- |
| Simple exploration | `explorer` | `gpt-5.6-sol`, `medium` | `"none"` |
| Simple implementation | `worker` | `gpt-5.6-sol`, `medium` | `"none"` |
| Documentation research | `docs_researcher` | `gpt-5.6-sol`, `medium` | `"none"` |
| Large-file, log, or repository partition scan | `bulk_scout` | `gpt-5.6-terra`, `medium` | `"none"` |
| Review, subtle debugging, or integration analysis | `reviewer` | `gpt-5.6-sol`, `high` | `"none"` or `"2"` |
| Complex or high-risk implementation | Primary, or one bounded child | `gpt-5.6-sol`, `xhigh` | `"none"` or `"2"` |
| Full decision-history dependency | Inherited/default | Inherit parent model and effort | `"all"` (rare) |

If custom roles are unavailable, reproduce the role's responsibility in the task capsule and use explicit model and
reasoning settings when the tool supports them. Do not assume all surfaces provide identical bounded-history behavior.
