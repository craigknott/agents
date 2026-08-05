Use when branching, staging, committing, pushing, creating pull requests, or addressing PR feedback.

- Follow repository conventions, keep commits focused, and stage only files that belong to the requested change.
- Honor repository commit policies. When DCO is enforced, include a matching `Signed-off-by` trailer in every commit.
- Follow the repository's PR template and naming rules. When none exist, use
  `<ISSUEID|NOISSUE> - [<low|medium|high>] - <Title>`.
- A fallback PR description should cover context, the change, validation, risk, and rollback.
- For every requested Git push or pull-request delivery workflow, use `no-mistakes` as the default gate unless the user
  or repository explicitly specifies another workflow. Treat its installed skill or repository documentation as the
  canonical procedure; do not duplicate its mechanics here or bypass it with a direct push.
- Initialize or run `no-mistakes` only when a push, pull-request delivery, or explicit validation request requires
  it—not when unrelated repository work begins.

Use `instructions/code-review.md` for risk classification.
