Use this file when a correction, discovered convention, tool failure pattern, or reusable workflow should become
persistent guidance. Capture learning deliberately so the instruction set improves without becoming noisy.

# When To Capture

- Capture a learning when I correct a recurring behavior or constraint.
- Capture a learning when a repository convention was discovered and is likely reusable in that repository.
- Capture a learning when validation, tooling, deployment, or review steps were missing or wrong.
- Capture a learning when the same workflow repeats and a skill or topic file would prevent future rediscovery.
- Do not capture one-off preferences, temporary workarounds, secrets, credentials, or project-private details globally.

# Where To Write

- Repo-specific convention: update the nearest repo `AGENTS.md`, `.agent.md`, or local topic file.
- Cross-repository personal default: update this directory's `AGENTS.md` or the matching `instructions/*.md` file.
- Repeated workflow: propose creating or updating a skill instead of expanding global guidance indefinitely.
- Tool-specific quirk: update the narrowest tool, skill, or topic instruction that owns that behavior.

# Writeback Rules

- Prefer proposing the instruction update before editing persistent guidance unless the user explicitly asks for the
  edit.
- Keep new rules actionable, scoped, and evidence-backed.
- Include the trigger condition, the expected behavior, and any validation or safety boundary.
- Remove or consolidate older rules if the new learning supersedes them.
- Do not write secrets, credentials, private customer data, or sensitive internal details into persistent guidance.
