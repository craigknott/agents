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
- Require concise summaries with file references and relevant failing lines, not raw logs or exploration transcripts.
- The primary agent owns user intent, skill selection and instruction reading, integration, conflict resolution, final
  validation, and completion. Treat child output as evidence to verify, not as automatically accepted work.
- Delegation does not reduce the completion standard in `instructions/workflow.md`.
