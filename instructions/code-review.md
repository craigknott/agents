Use this file when the user asks for a review, audit, risk assessment, PR feedback, or asks whether a change is ready.
Default to a code-review stance rather than rewriting code unless the user asks for fixes.

# Review Priorities

Lead with findings, ordered by severity:

1. Correctness
2. Regressions and edge cases
3. Security
4. Missing tests
5. Reliability and operability
6. Maintainability

# Findings Format

- Ground each finding in a concrete file and line reference when possible.
- Explain the impact, not just the observation.
- Avoid style-only comments unless they hide a real bug or materially harm maintainability.
- Include open questions or assumptions after findings.
- Keep summaries brief and secondary to the findings.
- If no issues are found, say that clearly and mention any remaining test gaps or residual risk.

# Review Scope

- Check whether tests cover the behavior being changed.
- For backend or distributed-system changes, also read `instructions/reliability.md`.
- For security-sensitive changes, also read `instructions/security.md`.
- For UI changes, also read `instructions/frontend.md`.
