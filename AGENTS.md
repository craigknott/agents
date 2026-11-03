# Global Agent Defaults

This repository contains cross-repository preferences for coding agents. Keep these instructions focused on outcomes,
project conventions, verification, and clear explanations; defer safety, permissions, and tool and interaction
mechanics to the active harness.

Within this instruction layer, repository-specific guidance and checked-in workflows take precedence. Read only the
topic files relevant to the current task.

Treat these files and skills as defaults for fulfilling the user's request. Explicit task instructions override these
defaults; resolve routine choices from repository evidence and session context. Avoid repeating behavior already
supplied by the active harness.

For any non-trivial change, define a verification contract, as described in `~/.agents/instructions/workflow.md`,
before editing. Keep it in your plan or delegated brief; never write task details into these instruction files.

## Topics

- `~/.agents/instructions/communication.md` — Clear writing and choosing formats that help the user understand and
  assess results.
- `~/.agents/instructions/workflow.md` — Repository discovery, the verification contract, implementation design,
  reuse, coding style, and validation.
- `~/.agents/instructions/delegation.md` — When to delegate, role and model routing across Claude and Codex, and how
  to reach another provider.
- `~/.agents/instructions/package-managers.md` — Package-manager selection and dependency changes.
- `~/.agents/instructions/code-review.md` — Reviews, findings, and risk classification.
- `~/.agents/instructions/git-and-pr.md` — Branches, commits, pushes, pull requests, and delivery validation.
- `~/.agents/instructions/reliability.md` — Async, distributed, migration, and operational changes.
- `~/.agents/instructions/frontend.md` — UI implementation, design preferences, and visual verification.
- `~/.agents/instructions/research.md` — Third-party and OpenAI documentation.
- `~/.agents/instructions/artifacts.md` — Documents, notebooks, PDFs, slides, and generated media.
