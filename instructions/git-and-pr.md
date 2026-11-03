Use when branching, staging, committing, pushing, creating pull requests, or addressing PR feedback.

- Follow repository conventions, keep commits focused, and stage only files that belong to the requested change.
- Apply the reviewability and slicing guidance in `~/.agents/instructions/workflow.md` when shaping commits and pull
  requests. State dependencies between ordered changes, and explain any coupling that prevents a safe split.
- Honor repository commit policies, such as DCO sign-off, for every commit in the delivery range, including automated
  commits.
- Follow the repository's PR template and naming rules. When none exist, use
  `<ISSUEID|NOISSUE> - [<low|medium|high>] - <Title>`.
- Scale the PR description to the change: explain the resulting behavior and validation, then material compatibility,
  feature-gate, rollout, risk, and rollback details when relevant.
- Use the repository's existing validation and delivery workflow. Before publishing changes, review the final diff
  and run the applicable tests, lint, and build checks. For pull-request delivery, follow required CI checks through
  completion and address failures within the task's scope. Report any checks that could not run or remain unresolved.
- `no-mistakes` is optional. Use it only when the user or repository explicitly requests it; do not require or
  initialize it for ordinary validation, pushes, or pull requests.
- Complete the requested delivery destination after validation. An explicit request to land on `main` includes that
  final integration; creating a review branch for the gate is an intermediate step.

Use `~/.agents/instructions/code-review.md` for risk classification.
