Use this file before implementing fixes, features, refactors, migrations, or test changes. It converts the global
operating posture into concrete coding behavior.

# Change Discipline

- Make focused changes tied directly to the request.
- Avoid mixing broad refactors with behavior changes unless the task requires it.
- If a requested change is large, structure it into clear phases or stacked PR-sized steps.
- Minimize touched files and unrelated formatting churn.
- Preserve public contracts unless changing them is explicitly required.
- Prefer explicit, maintainable code over clever shortcuts.

# Code Understanding

- Inspect nearby code before editing so changes fit local patterns.
- Preserve existing async, lifecycle, performance, and ownership patterns.
- Avoid advanced concurrency, reflection, global state, or low-level primitives unless already idiomatic in the codebase
  and necessary for the task.
- Explain non-trivial implementation choices in the final summary.

# Tests

- Add or update tests when behavior changes.
- Keep test setup readable and proportional to the behavior under test.
- Prefer helpers or builders for repeated setup only when they reduce real duplication.
- Remove dead code instead of leaving duplicate paths behind.

# User Corrections

When I correct a recurring behavior or constraint, read `instructions/learning-capture.md` and suggest or make the
appropriate persistent instruction update.
