Use this file when work is large, parallelizable, unclear, or benefits from specialized exploration, review,
implementation, or browser-debugging tracks.

# When To Use Subagents

Prefer narrow specialization over one overloaded agent for large or multi-track tasks.

Good split patterns:

- Explorer or mapper
- Reviewer
- Docs researcher
- Browser debugger
- Implementation worker

# Delegation Rules

- Use subagents when parallel exploration or isolated reasoning will materially improve the work.
- Give each subagent a narrow objective and concrete output.
- Do not delegate reading or interpreting selected skill instructions; the main agent must read applicable skill files
  itself before acting on them.
- Reconcile subagent outputs against repository evidence before implementing changes.
- Do not hide uncertainty behind subagent summaries; report remaining risk directly.
