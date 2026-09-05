Use when branching, staging, committing, pushing, creating pull requests, or addressing PR feedback.

- Follow repository conventions, keep commits focused, and stage only files that belong to the requested change.
- Apply the reviewability and slicing guidance in `instructions/workflow.md` when shaping commits and pull requests.
  State dependencies between ordered changes, and explain any coupling that prevents a safe split.
- Honor repository commit policies, including automated commits. When DCO is enforced, sign off every commit with a
  trailer matching its author, and verify the entire delivery range before publishing and after automated commits.
  Repair each offending commit in history; a later signed commit or cryptographic signature cannot supply its trailer.
  Automated phases must preserve this policy or leave commits to the owning workflow; a DCO repair must return a fully
  signed range.
- Follow the repository's PR template and naming rules. When none exist, use
  `<ISSUEID|NOISSUE> - [<low|medium|high>] - <Title>`.
- Scale the PR description to the change: explain the resulting behavior and validation, then material compatibility,
  feature-gate, rollout, risk, and rollback details when relevant.
- For every requested Git push or pull-request delivery workflow, use `no-mistakes` as the default gate unless the user
  or repository explicitly specifies another workflow. Treat its installed skill or repository documentation as the
  canonical procedure; do not duplicate its mechanics here or bypass it with a direct push.
- Initialize or run `no-mistakes` only when a push, pull-request delivery, or explicit validation request requires
  it—not when unrelated repository work begins.
- Complete the requested delivery destination after validation. An explicit request to land on `main` includes that
  final integration; creating a review branch for the gate is an intermediate step.

Use `instructions/code-review.md` for risk classification.
