These are my global, cross-repository defaults for coding agents. Treat this file as the
entry-point router: read it every time, then load only the topic files whose triggers match the task.

# Quick Reference

- Scope: personal defaults for coding, review, research, artifact, and tool-use tasks.
- Source of truth: `AGENTS.md`; agent-specific files such as `CLAUDE.md` and `GEMINI.md` should defer here.
- Instructions directory: `instructions/`

# Authority

- Prefer the closest repo-specific `AGENTS.md`, `.agent.md`, `CLAUDE.md`, or equivalent local guidance.
- When local guidance conflicts with these global defaults, follow the closest local guidance.
- When a tool, manifest, CI workflow, or checked-in script expresses a project convention, prefer that evidence over
  generic assumptions.
- When I correct a recurring behavior or constraint, read `instructions/learning-capture.md`.

# Router Rules

- Before acting, decide which topic files match the current task and read those files first.
- Read multiple topic files when multiple triggers apply.
- Do not load every file in `instructions/` by default.
- If no topic matches, proceed with only this root file and the local repository guidance.
- Keep new global guidance in the most specific topic file; keep the root file small.

# Boil The Lake

This is the global execution standard. When I ask for work, the expected answer is the finished product, not a plan to
build it, unless I explicitly ask for planning or constraints make implementation unsafe.

- Do the whole thing when the permanent solve is within reach.
- Complete means fully finishing the requested scope, not expanding into unrelated work.
- Search before building.
- Test before shipping.
- Prefer the complete, root-cause fix over a superficial patch or workaround.
- Do not leave dangling work when tying it off is practical.
- Add or update documentation when it is needed to make the change durable.
- Time, fatigue, and complexity are not excuses for avoidable incompleteness.
- The standard is complete, verified, reviewable work.

# Topics

- `instructions/repo-orientation.md` — Read before changing or reviewing code, exploring a new repository, or choosing
  a workflow from local evidence.
- `instructions/planning-and-assumptions.md` — Read before asking clarifying questions, making assumptions, planning
  phases, or deciding whether to proceed.
- `instructions/package-managers.md` — Read before installing, updating, or running package-manager commands.
- `instructions/validation.md` — Read before deciding completion criteria, tests, typechecks, linters, formatters,
  security checks, or other verification steps.
- `instructions/risk.md` — Read before assigning PR risk, choosing validation breadth, or describing residual risk.
- `instructions/coding.md` — Read before implementing fixes, features, refactors, migrations, or test changes.
- `instructions/code-review.md` — Read when the user asks for a review, audit, risk assessment, or PR feedback.
- `instructions/git-and-pr.md` — Read before branching, staging, committing, creating PRs, or responding to PR
  feedback.
- `instructions/reliability.md` — Read for backend, distributed-system, queue, worker, async, migration, rollout, or
  operational changes.
- `instructions/security.md` — Read for auth, authorization, secrets, credentials, CVEs, dependency upgrades,
  containers, threat models, or other security-sensitive work.
- `instructions/frontend.md` — Read for UI, browser, frontend, design-to-code, visual QA, Electron, games, or
  canvas/3D work.
- `instructions/local-environment.md` — Read before starting, stopping, or relying on local dev servers, background
  processes, containers, emulators, ports, or service dependencies.
- `instructions/research.md` — Read for fresh, version-sensitive, library/framework, API, market, legal, financial, or
  source-cited research.
- `instructions/tools-and-skills.md` — Read before selecting specialized skills, MCP tools, browser automation,
  generated images, OpenAI docs, Context7, or other task-specific tools.
- `instructions/mcp.md` — Read before using MCP connectors, external work data, Slack, Drive, Jira, Bitbucket, or
  other side-effect-capable integrations.
- `instructions/artifacts.md` — Read for docs deliverables, PDFs, notebooks, LaTeX, slide decks, generated media, or
  other durable artifacts.
- `instructions/subagents.md` — Read when work is large, parallelizable, unclear, or benefits from specialized
  exploration, review, implementation, or browser-debugging tracks.
- `instructions/communication.md` — Read before progress updates, final summaries, handoffs, or when reporting
  uncertainty.
- `instructions/learning-capture.md` — Read when a recurring correction, missing convention, tool failure pattern, or
  reusable workflow should become persistent guidance.

# Standing Safety

- Never expose secrets, tokens, credentials, keys, or `.env` values in logs, examples, comments, or summaries.
- Do not weaken authentication, authorization, input validation, or secret handling without explicit instruction.
- Do not run destructive commands, delete files, reset history, or revert user changes unless the user clearly asked
  for it.
- Preserve user work in dirty worktrees. If unrelated changes exist, leave them alone.
