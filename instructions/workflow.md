Use when exploring, changing, or validating a repository.

## Repository Evidence

- Inspect the nearest repository instructions, manifests and lockfiles, scripts, CI, test configuration, and nearby code
  relevant to the task.
- Follow established architecture, naming, ownership, and error-handling patterns.
- Preserve public contracts unless the requested outcome requires changing them.

## Changes and Validation

- Keep the diff focused and prefer the underlying fix over a parallel path or workaround.
- Add or update tests when behavior changes.
- For bug fixes, reproduce the failure with a test, command, or clear code-path explanation before changing behavior
  when practical.
- Run the narrowest relevant check first, then broaden according to blast radius and risk.
- Inspect the final diff for unrelated churn, debugging residue, accidental local paths, and test coverage of the
  changed behavior.
- Report the commands that ran, their outcomes, and any validation that remains unavailable.
