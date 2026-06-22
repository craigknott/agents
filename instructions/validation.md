Use this file before deciding what tests, typechecks, linters, formatters, security scans, or visual checks to run.
Report exactly what was run and do not claim success beyond that evidence.

# Completion Loop

For implementation tasks:

1. Reproduce, characterize, or explain the current behavior before changing it.
2. Make the smallest focused change that addresses the behavior.
3. Run the narrowest relevant validation.
4. Fix failures and rerun the same validation until it passes or a real blocker is found.
5. Broaden validation based on risk and blast radius.
6. Inspect the final diff for unrelated changes, secrets, debug code, and accidental churn.
7. Summarize changes, validation, and residual risk.

# Validation Order

Always validate the smallest relevant scope first, then broaden as confidence increases:

1. Targeted test or check for the changed behavior
2. Typecheck, lint, or formatter for touched code
3. Package-level or service-level test suite
4. Integration or end-to-end checks when behavior crosses boundaries

# Bugfix Verification

- For bug fixes, reproduce the failure first with a test, command, log, or clear code-path explanation.
- Prefer adding a failing regression test before changing behavior.
- If reproduction is impossible, state why and identify the evidence used instead.
- Do not claim a bug is fixed unless the original failure mode is covered by validation or explicitly reasoned through.

# Failure Handling

- When validation fails, inspect the first relevant failure, fix the cause, and rerun the same command.
- Do not switch to broader validation while targeted validation is still failing.
- Separate unrelated pre-existing failures from failures caused by the current change.
- After three failed attempts on the same issue, stop and report the blocker with evidence.

# Command Failure Handling

- When a command fails before meaningful validation runs, identify whether the cause is code, environment, auth,
  sandboxing, missing services, stale servers, or missing dependencies.
- Fix code-caused failures directly.
- For environment or dependency failures, inspect the repository workflow before choosing an install, setup, or service
  command.
- If escalation, credentials, external services, or destructive cleanup would be required, report the blocker and the
  exact command or permission needed.
- Do not treat environment setup failure as validation failure of the code under test.

# Validation Selection

- Pure docs change: run formatting, linting, link, render, or generated-output checks when relevant.
- Unit-level logic change: run the targeted unit test, then package tests if risk warrants.
- Type or interface change: run targeted tests plus the relevant typecheck or compile check.
- UI behavior change: run targeted tests plus browser or visual verification.
- Dependency change: install or update with the canonical package manager, inspect lockfiles, and run relevant tests.
- Security-sensitive dependency change: include dependency, container, or vulnerability checks when relevant.
- Config, migration, queue, auth, or API boundary change: run targeted tests plus broader service or integration checks.
- Use `instructions/risk.md` to decide how far to broaden validation.

# Test Strategy

- Add or update tests when behavior changes.
- Design unit tests first.
- Use integration or end-to-end tests deliberately for cross-component interactions or critical flows that unit tests
  cannot cover well.
- Prefer fewer high-value tests over many near-duplicates.
- Use table-driven or parameterized tests instead of copy-pasted cases when the codebase supports them.
- Name tests by business behavior rather than implementation detail.
- Prune noisy setup, oversized fixtures, and overly permissive matchers that hide behavior changes.

# Diff Review

Before final response or PR creation:

- Inspect the diff.
- Remove debug logs, commented-out code, accidental formatting churn, and unrelated edits.
- Confirm tests match the changed behavior rather than implementation details.
- Confirm no secrets, credentials, or local-only paths were introduced.

# Reporting

- Name every command actually run.
- If validation could not be run, say exactly why.
- If only partial validation was run, state the remaining risk.
- For UI work, include browser or visual verification when behavior depends on rendering.
- For security-sensitive work, include stack-native dependency or vulnerability checks when relevant.
- Say "validated with X" only when X actually ran.
- Distinguish compile, type, test, visual, security, and reasoning-only confidence.
