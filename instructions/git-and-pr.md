Use this file before branching, staging, committing, creating pull requests, updating pull requests, or responding to PR
feedback.

# Worktree Safety

- You may be in a dirty worktree.
- Never revert existing changes you did not make unless explicitly requested.
- If unrelated changes exist, ignore them.
- If user changes affect the files you need, read them carefully and work with them.
- Ask how to proceed only when existing changes make the task impossible.
- Do not use destructive commands such as `git reset --hard` or `git checkout --` unless the user clearly asked for
  them.

# Commits

- Do not commit unless the user asks.
- Keep commits focused and reviewable.
- Use non-interactive git commands whenever possible.
- Stage only files relevant to the requested work.

# Pull Requests

- Use repository conventions for PR titles, descriptions, templates, labels, and reviewers.
- If the repository has no PR title convention, use `<ISSUEID|NOISSUE> - [<low|medium|high>] - <Title>`.
- Use `NOISSUE` when there is no tracked issue ID.
- Use `instructions/risk.md` to choose the risk level.
- Summarize what changed, what was verified, and meaningful residual risk.
- When addressing review comments, resolve the underlying issue rather than only satisfying wording.

# CI And Review Feedback

- For failing CI, inspect the failing check or log before changing code.
- Reproduce the failure locally when practical, using the smallest relevant command.
- Fix the root cause, rerun targeted validation, then broaden based on `instructions/risk.md`.
- Separate pre-existing or flaky failures from failures caused by the current change.
- When updating a PR after CI or review feedback, summarize the fix and the validation that now passes.

# Fallback PR Description

Use this structure only when the repository has no PR template or description convention:

```markdown
## Human Readable: Context

- Why this change exists
- What changed at the product, system, or developer-experience level
- What validation was run
- What risk remains, if any

## Bot Readable: Details

- Issue ID: ISSUEID or NOISSUE
- Risk level: low, medium, or high; include the main risk driver
- Change type: bugfix, feature, refactor, test, docs, infra, or security
- Primary files or modules changed
- Behavior, API, schema, config, or dependency changes
- Validation commands and results
- Follow-up work, or none

## Rollback Strategy

- State whether a normal revert is sufficient
- Note any feature flag, config toggle, migration rollback, data repair, or manual step required
- If rollback is unsafe or incomplete, say why and name the safest mitigation
```
