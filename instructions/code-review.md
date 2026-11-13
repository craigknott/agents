Use for code reviews, audits, readiness checks, and risk assessments. Review without editing unless fixes are requested.

## Findings

- Lead with actionable findings ordered by severity.
- Check the request before the diff: confirm that the change does what was asked, and report a wrong or unstated
  assumption as a finding.
- Prioritize correctness, regressions, security, missing tests, reliability, and maintainability.
- Give each finding a precise file and line reference, explain its impact, and avoid style-only comments.
- Apply the reviewability and readability guidance in `~/.agents/instructions/workflow.md`. Treat its size guidance as
  a trigger to check reviewability, not a hard limit. Report concrete blind spots or maintainability risks rather than
  personal style preferences.
- Treat missing verification evidence for behavior a person can see or run as a validation gap. Treat a check that
  was changed, skipped, or mocked to pass, without a stated reason, as a finding.
- If there are no findings, say so and note any validation gaps or residual risk.

## Re-checks

When you are asked to re-check fixes for earlier findings:

- Mark each earlier finding as resolved or still open, and say what you checked. When the author declined a finding,
  say whether you accept the reason.
- Review the fixes for new problems. Leave the unchanged code alone, unless a fix exposes a problem in it or the
  first review missed a serious defect.

## Risk

Classify risk with the levels in `~/.agents/instructions/workflow.md`. Name the concrete risk driver rather than
reporting only the level. When the author stated a level, check it against the diff.
