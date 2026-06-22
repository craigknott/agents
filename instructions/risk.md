Use this file before assigning PR risk, choosing validation breadth, or describing residual risk. Risk is about likely
blast radius, reversibility, user impact, and confidence, not effort.

# Risk Levels

- Low: docs-only, tests-only, comments, isolated dead-code deletion, or small internal changes with no runtime behavior
  change.
- Low: reversible code changes limited to one narrow path with targeted validation and no public contract impact.
- Medium: user-visible behavior changes, shared code paths, dependency updates, config changes, non-critical API
  changes, or changes where validation is meaningful but not exhaustive.
- Medium: changes that are reversible by normal revert but may require careful deploy timing or monitoring.
- High: auth, authorization, secrets, data integrity, persistence, migrations, payments, critical workflows, broad
  dependency upgrades, public API contracts, or cross-service behavior.
- High: changes with difficult rollback, incomplete validation, large blast radius, production-only behavior, or unclear
  failure modes.

# Validation Expectations

- Low risk: targeted validation is usually enough; broaden only if local evidence suggests hidden coupling.
- Medium risk: run targeted validation plus typecheck, lint, package tests, or service tests that cover affected paths.
- High risk: run targeted and broad validation, include integration or end-to-end checks when relevant, and call out any
  validation that could not be run.

# Reporting Risk

- In PR titles, use `[low]`, `[medium]`, or `[high]` when the repository has no stronger convention.
- In PR descriptions and final summaries, name the specific risk driver instead of only saying the risk level.
- If risk is high because validation is incomplete, say what evidence is missing and what would reduce the risk.
