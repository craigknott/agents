Use when delegating work to subagents, other models, or another provider's agent.

## When to Delegate

- Delegate independent work when it improves speed, quality, or independence of judgment, and the active harness
  permits it. Do small lookups and checks yourself.
- Give each child a complete brief: goal, scope, files to read, what is already ruled out, the verification contract
  from `~/.agents/instructions/workflow.md`, and the expected output. The brief is all the context a child has.
- Avoid duplicate assignments. Treat child results as claims; verify them before integration.
- A delegated child does the work itself. It never delegates further.

## Routing

Route by job, not by habit. The roles exist on both platforms with the same names.

| Role | Job | Claude | Codex |
|---|---|---|---|
| `scout` | High-volume scans of files, logs, or repository partitions | Haiku | `gpt-6-luna` medium |
| `explorer` | Targeted evidence gathering and path tracing | Sonnet medium | `gpt-6.1-sol` medium |
| `worker` | Bounded implementation with a verification contract | Sonnet medium | `gpt-6.1-sol` medium |
| `reviewer` | Review of well-scoped changes | Opus high | `gpt-6.1-sol` high |
| `deep_reviewer` | Ambiguous, complex, or high-risk review and design checks | Fable high | `gpt-6-astra` high |

Codex also has `docs_researcher` for OpenAI and Context7 documentation lookups.

## How to Delegate

- **Same provider:** use the harness's native subagent tool with the role name.
- **Other provider:** use the cross-provider delegation mechanism that the active harness provides, and follow the
  harness's rules for it. This pack does not ship one. When the harness has none, say so and keep the work on the
  current provider.
- Only `worker` may write, so give it its own worktree or a clean scope. Calls can take several minutes; run them in
  the background when the harness supports it.
- Treat a delegation that fails, times out, or returns no output as **not done**, never as "no findings". Report it
  and retry or proceed without it.

## Cross-Provider Review

For an independent review of medium- or high-risk work, use a reviewer from the other model family: the other
provider's `reviewer` or `deep_reviewer`. A different model family is less likely to share the implementer's blind
spots.

- Do not assume that the reviewer loaded these instructions or its role file. Make the brief complete without them:
  say that the review is read-only, include the role's instructions, and include the risk levels and the findings
  format that the reviewer must use.
- Give the reviewer the request, its assumptions, the contract, and the diff, not your conclusions. Include the output
  of any check that the reviewer cannot run.
- For a re-check after fixes, write a new brief that is complete in the same way, because the reviewer may start in
  a fresh context. Add the earlier findings, what you changed for each one or why you declined it, and the diff or
  the exact locations of the fixes. Ask the reviewer to mark each finding as resolved or still open, and to review
  the fixes only.
- When no reviewer from the other family is reachable, use a same-provider reviewer in a fresh context. Say in the
  report that the review was not cross-family.
