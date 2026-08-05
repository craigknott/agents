Use when exploring, changing, or validating a repository.

## Repository Evidence

- Inspect the nearest repository instructions, manifests and lockfiles, scripts, CI, test configuration, and nearby code
  relevant to the task.
- Follow established architecture, naming, ownership, and error-handling patterns.
- Preserve public contracts unless the requested outcome requires changing them.

## Design and Implementation

- Follow DRY (Don't Repeat Yourself): search for existing modules, functions, methods, types, constants, schemas,
  configuration, and helpers before adding a new implementation. Reuse or reference the canonical definition instead
  of copying it.
- Prefer a small, cohesive generalization of an existing abstraction when it cleanly supports the new use case and
  prevents repeated logic. Do not combine unrelated behavior or introduce speculative indirection without concrete
  reuse.
- Keep business logic direct and as simple as the domain permits. Separate domain rules from transport, persistence,
  framework, and presentation concerns when that separation makes the behavior easier to understand or test.
- Apply the single responsibility principle where it improves cohesion: each module, type, function, or method should
  have one clear purpose and reason to change. Split mixed responsibilities, but avoid mechanical fragmentation that
  makes the code harder to follow.
- Follow the repository's language- and framework-specific style, formatter, linter, and idioms. When local guidance is
  absent, follow the language's official or broadly accepted conventions.
- Keep the diff focused and prefer the underlying fix over a duplicate path, workaround, or unrelated refactor.

## Completion and Validation

- Deliver the complete requested behavior, including necessary wiring, edge cases, cleanup, tests, and documentation.
  Do not stop at scaffolding, a partial code path, or avoidable TODOs when the remaining work is in scope and feasible.
- Add or update tests when behavior changes.
- For bug fixes, reproduce the failure with a test, command, or clear code-path explanation before changing behavior
  when practical.
- Run the narrowest relevant check first, then broaden according to blast radius and risk.
- Inspect the final diff for unrelated churn, debugging residue, accidental local paths, and test coverage of the
  changed behavior.
- Report the commands that ran, their outcomes, and any validation that remains unavailable.
