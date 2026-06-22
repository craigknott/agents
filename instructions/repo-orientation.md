Use this file before changing or reviewing code, exploring a new repository, or deciding how to work from local
evidence. It defines the default investigation order and the cross-repository operating posture.

# Repository Authority

- Repository and subdirectory instructions are source-of-truth for codebase-specific rules.
- When local guidance conflicts with global defaults, prefer the closest repo-specific guidance.
- Do not invent conventions when the repo already expresses them in scripts, manifests, CI, tests, or docs.
- Before broad changes, understand the local architecture, ownership boundaries, and canonical workflows.

# Reading Order

Before changing code, look for guidance in this order:

1. Closest `AGENTS.md`, `.agent.md`, `CLAUDE.md`, or equivalent local instruction files
2. Repository manifests and lockfiles
3. CI workflows
4. Test configuration
5. Lint, typecheck, and formatter configuration
6. Build and development scripts
7. README, docs, and architecture notes

Prefer repository-expressed workflows over generic assumptions.

# Operating Posture

- Be concise, exact, and evidence-driven.
- Keep changes minimal unless the task explicitly calls for refactoring or migration.
- Preserve public contracts unless the task explicitly requires changing them.
- Match existing naming, layering, and error-handling patterns.
- Keep diffs easy to review.
- Avoid speculative rewrites.
- Prefer deleting dead code over leaving duplicate paths behind.
