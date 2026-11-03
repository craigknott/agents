Use when delegating work to subagents, other models, or another provider's agent.

## When to Delegate

- Delegate independent work when it improves speed, quality, or independence of judgment, and the active harness
  permits it. Do small lookups and checks yourself.
- Give each child a complete brief: goal, scope, files to read, what is already ruled out, the verification contract
  from `~/.agents/instructions/workflow.md`, and the expected output. The brief is all the context a child has.
- Avoid duplicate assignments. Treat child results as claims; verify them before integration.
- A delegated child does the work itself. It never delegates further. `AGENT_DEPTH` set to 1 or higher means you are
  a child.

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

For an independent review of medium- or high-risk work, use the other provider's `reviewer` or `deep_reviewer`. A
different model family is less likely to share the implementer's blind spots. Give it the request, the contract, and
the diff, not your conclusions.

## How to Delegate

1. **Same provider:** use the harness's native subagent tool with the role name.
2. **Other provider, with a harness tool:** when the harness provides a cross-provider delegation tool, use it and
   follow the harness's rules for it. Do not fall back to a CLI.
3. **Claude Code to Codex:** use the `codex:codex-rescue` subagent from OpenAI's `codex` plugin. Put the role's model
   and effort first in the prompt, for example `--model gpt-6.1-sol --effort high` for `reviewer`. It runs with write
   access unless the prompt says the task is read-only, so state "read-only review, no edits" for every role except
   `worker`. The `/codex:review` and `/codex:adversarial-review` commands are user-only; suggest them when the user
   wants a manual check.
4. **Codex or another tool to Claude Code:** run the shared script:

   ```sh
   ~/.agents/scripts/claude-delegate.sh <role> [-C <repo>] [-t <seconds>] <brief.md
   ```

   It loads the Claude role file, marks the child with `AGENT_DEPTH`, and prints only Claude's final message. Read-only
   roles run restricted: they can read files and run read-only `git` commands only, so include any test output they
   need in the brief. The default timeout is 30 minutes.

Treat a delegation that fails, times out, or returns no output as **not done**, never as "no findings". Report it and
retry or proceed without it. Only `worker` may write, so give it its own worktree or a clean scope. Calls can take
several minutes; run them in the background when the harness supports it.
