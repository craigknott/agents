Use this file when work is long-running, token-heavy, parallelizable, unclear, or benefits from specialized exploration,
review, implementation, verification, or browser-debugging tracks.

# When To Use Subagents

Prefer narrow specialization over one overloaded agent for large, long-running, token-heavy, or multi-track tasks. The
default for substantial goals is to split work into granular sub-agent or thread tasks whenever doing so reduces the
amount of irrelevant context carried through the main conversation.

Good split patterns:

- Explorer or mapper
- Reviewer
- Docs researcher
- Browser debugger
- Implementation worker
- Verification worker

# Delegation Rules

- Use subagents aggressively when parallel exploration, isolated reasoning, independent review, or context isolation
  will materially improve the work or reduce token load in the main thread.
- For long-running goals, look for delegation points at each phase: repository mapping, design options, implementation
  slices, test investigation, browser debugging, documentation updates, and review.
- Give each subagent a narrow objective, minimal necessary context, owned files or responsibility when editing, and a
  concrete output contract.
- Prefer several focused subagents over one broad subagent when tasks are independent and the tool supports parallel
  work.
- Do not delegate reading or interpreting selected skill instructions; the main agent must read applicable skill files
  itself before acting on them.
- Keep the main agent responsible for orchestration, integration, final decisions, and preserving user intent.
- Reconcile subagent outputs against repository evidence before implementing or accepting changes.
- Before pushing changes, feed findings from subagent or thread reviews into the required self-review and resolve,
  explicitly defer, or escalate them.
- Do not hide uncertainty behind subagent summaries; report remaining risk directly.
- Do not delegate when the overhead, tool limits, or required context would exceed the benefit, or when the user has
  asked for local-only work.
