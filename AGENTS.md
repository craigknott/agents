# Global Agent Defaults

This repository contains cross-repository preferences for coding agents. Keep these instructions focused on outcomes,
project conventions, verification, and clear explanations; defer safety, permissions, and tool and interaction
mechanics to the active harness.

Within this instruction layer, repository-specific guidance and checked-in workflows take precedence. Read only the
topic files relevant to the current task.

Treat these files and skills as defaults for fulfilling the user's request. Explicit task instructions override these
defaults; resolve routine choices from repository evidence and session context. Avoid repeating behavior already
supplied by the active harness.

For any non-trivial change, state the request and its assumptions, then define a verification contract, as described
in `~/.agents/instructions/workflow.md`, before editing. A change is trivial only when it changes no behavior and one
obvious check proves it, such as a typo or formatting fix. Keep the contract in your plan or delegated brief; never
write task details into these instruction files.

In every response, lead with the answer or outcome, separate observed facts from assumptions, and state what you did
not verify. `~/.agents/instructions/communication.md` has the full writing guidance.

## Topics

- `~/.agents/instructions/communication.md` — Clear writing and choosing formats that help the user understand and
  assess results.
- `~/.agents/instructions/workflow.md` — Repository discovery, request assumptions, risk levels, the verification
  contract, implementation design, reuse, coding style, and validation.
- `~/.agents/instructions/delegation.md` — When to delegate, role and model routing across Claude and Codex, and
  cross-provider review.
- `~/.agents/instructions/package-managers.md` — Package-manager selection and dependency changes.
- `~/.agents/instructions/code-review.md` — Reviews, findings, and checking the stated risk.
- `~/.agents/instructions/git-and-pr.md` — Branches, commits, pushes, pull requests, stacks, verification evidence,
  and delivery validation.
- `~/.agents/instructions/reliability.md` — Async, distributed, migration, and operational changes.
- `~/.agents/instructions/frontend.md` — UI implementation, design preferences, and visual verification.
- `~/.agents/instructions/research.md` — Third-party and OpenAI documentation.
- `~/.agents/instructions/artifacts.md` — Documents, notebooks, PDFs, slides, and generated media.
