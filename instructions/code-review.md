Use for code reviews, audits, readiness checks, and risk assessments. Review without editing unless fixes are requested.

## Findings

- Lead with actionable findings ordered by severity.
- Prioritize correctness, regressions, security, missing tests, reliability, and maintainability.
- Give each finding a precise file and line reference, explain its impact, and avoid style-only comments.
- If there are no findings, say so and note any validation gaps or residual risk.

## Risk

- **Low:** Documentation, tests, or isolated internal changes with no public behavior change.
- **Medium:** User-visible behavior, shared paths, dependencies, configuration, or non-critical API changes.
- **High:** Authentication, data integrity, payments, migrations, public contracts, difficult rollback, or materially
  incomplete validation.

Name the concrete risk driver rather than reporting only the level.
