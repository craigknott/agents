@~/.agents/AGENTS.md
@~/.codex/RTK.md

# Codex Subagent Defaults

Apply these Codex-specific rules together with the global agent instructions above.

## Context and Task Capsules

- Ordinary delegations must use `fork_turns="none"` and a self-contained, bounded task capsule.
- Include the objective, exact repository or file scope, relevant decisions, constraints, deliverable, and focused
  verification requirements. Exclude unrelated conversation history and raw exploration logs.
- Use `fork_turns="2"` only when the latest clarification or failure is essential to the task. Use `fork_turns="all"`
  only when the complete decision history is indispensable; full-history forks inherit the parent model and effort.

## Routing

Use these defaults when the Codex surface exposes the corresponding role and model controls:

| Task | Role | Model | Effort |
| --- | --- | --- | --- |
| Targeted repository exploration with Sol | `explorer_sol` | `gpt-6.1-sol` | medium |
| Bounded implementation and verification with Sol | `worker_sol` | `gpt-6.1-sol` | medium |
| Focused correctness, regression, or test review with Sol | `reviewer_sol` | `gpt-6.1-sol` | high |
| Targeted repository exploration | `explorer` | `gpt-6-astra` | medium |
| Bounded implementation and verification | `worker` | `gpt-6-astra` | medium |
| OpenAI or library documentation research | `docs_researcher` | `gpt-6-astra` | medium |
| Large-file, log, or repository-partition scan | `bulk_scout` | `gpt-6-astra` | medium |
| Correctness, security, regression, or test review | `reviewer` | `gpt-6-astra` | high |

Prefer the Sol roles for well-scoped exploration, implementation, and review. Keep the Astra roles available for
ambiguous investigations, specialized research or scans, and complex or high-risk review. Honor an explicitly
requested model. The Sol definitions pin both model and effort, so select the corresponding Astra role when needed
instead of trying to override a Sol role's configuration.

Keep complex or high-risk implementation with the primary agent unless one bounded `worker` task provides useful
isolation. In that rare case, prefer `gpt-6-astra` with xhigh effort and the smallest sufficient context.

If a Codex surface does not expose a named role, reproduce that role's responsibility in the task capsule and set the
model and effort explicitly when supported. If it does not support bounded-history controls, provide the smallest
available context and do not assume its context behavior matches another Codex surface.
