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
| Targeted repository exploration | `explorer` | `gpt-5.6-sol` | medium |
| Bounded implementation and verification | `worker` | `gpt-5.6-sol` | medium |
| OpenAI or library documentation research | `docs_researcher` | `gpt-5.6-sol` | medium |
| Large-file, log, or repository-partition scan | `bulk_scout` | `gpt-5.6-terra` | medium |
| Correctness, security, regression, or test review | `reviewer` | `gpt-5.6-sol` | high |

Keep complex or high-risk implementation with the primary agent unless one bounded `worker` task provides useful
isolation. In that rare case, prefer `gpt-5.6-sol` with xhigh effort and the smallest sufficient context.

If a Codex surface does not expose a named role, reproduce that role's responsibility in the task capsule and set the
model and effort explicitly when supported. If it does not support bounded-history controls, provide the smallest
available context and do not assume its context behavior matches another Codex surface.
