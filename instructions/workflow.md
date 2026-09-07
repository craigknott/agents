Use when exploring, changing, or validating a repository.

## Repository Evidence

- Inspect the nearest repository instructions, manifests and lockfiles, scripts, CI, test configuration, and nearby code
  relevant to the task.
- Follow established architecture, naming, ownership, and error-handling patterns.

## Backward Compatibility

- Preserve existing public contracts unless the requested outcome requires changing them. Infer routine compatibility
  choices from the task, callers, tests, and repository conventions.
- Clarify only an unresolved compatibility choice that materially changes the result; continue independent work while
  it is unresolved. Apply the decision consistently to implementation, tests, documentation, and rollout.

## Design and Implementation

- Reuse canonical definitions and existing abstractions. Generalize only for concrete reuse; avoid duplicate paths,
  speculative indirection, and mechanical fragmentation.
- Keep domain logic and control flow direct. Separate responsibilities when it improves cohesion, understanding, or
  testing.
- Follow the repository's language- and framework-specific style, formatter, linter, and idioms. When local guidance is
  absent, follow the language's official or broadly accepted conventions.
- Keep the diff focused and prefer the underlying fix over a duplicate path, workaround, or unrelated refactor.

## Reviewability and Readability

- Treat reviewability as part of correctness. Shape work as the smallest coherent slice that delivers understandable,
  testable behavior; do not use one-shot completion to justify a diff that is too broad to review confidently.
- Separate independent refactors, dependency or generated-file churn, migrations, and behavior changes when practical.
  If a change cannot be divided safely, explain the coupling and give reviewers a clear path through it.
- Optimize code for the next reader: use names that convey intent, keep control flow direct, keep responsibilities
  cohesive, and document non-obvious reasons or invariants rather than restating the code.
- Do not sacrifice clarity merely to reduce line count or diff size.

## Feature Gates

- Use the repository's existing feature-gate system when new behavior needs staged rollout or independent operational
  control. Avoid adding a gate to a routine fix without a rollout need, or introducing a parallel flag system.
- Test enabled and disabled paths, choose the default according to the compatibility and rollout decisions, and define
  when temporary gates and old paths will be removed.

## Completion and Validation

- Deliver the complete requested behavior, including necessary wiring, edge cases, cleanup, tests, and documentation.
  Do not stop at scaffolding, a partial code path, or avoidable TODOs when the remaining work is in scope and feasible.
- Add or update tests for meaningful behavior changes and regressions. For low-impact documentation, configuration,
  or cosmetic changes, prefer the relevant parser, linter, existing checks, or visual inspection. Do not add tests that
  merely match implementation text or restate instructions.
- For bug fixes, reproduce the failure with a test, command, or clear code-path explanation before changing behavior
  when practical.
- Run the narrowest relevant checks and all required repository checks. Broaden or repeat only for new changes,
  failures, or a concrete unresolved risk; passing checks should lead to delivery.
- Inspect the final diff for unrelated churn, debugging residue, accidental local paths, and test coverage of the
  changed behavior.
- Report the commands that ran, their outcomes, and any validation that remains unavailable.
