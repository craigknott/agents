Use when branching, staging, committing, pushing, creating pull requests, splitting large changes, or addressing PR
feedback.

- Follow repository conventions, keep commits focused, and stage only files that belong to the requested change.
- Apply the reviewability and slicing guidance in `~/.agents/instructions/workflow.md` when shaping commits and pull
  requests. State dependencies between ordered changes, and explain any coupling that prevents a safe split.
- Honor repository commit policies, such as DCO sign-off, for every commit in the delivery range, including automated
  commits.
- Follow the repository's PR template and naming rules. When none exist, title the pull request
  `<ISSUEID|NOISSUE> - [<low-risk|medium-risk|high-risk>] - <Title>`. This format is for pull-request titles only;
  commit subjects follow the repository's own history.
- Scale the PR description to the change: explain the resulting behavior and validation, then material assumptions,
  compatibility, feature-gate, rollout, risk, and rollback details when relevant. Include the verification evidence
  described below.
- Use the repository's existing validation and delivery workflow. Before publishing changes, review the final diff
  and run the applicable tests, lint, and build checks. For pull-request delivery, follow required CI checks through
  completion and address failures within the task's scope. Report any checks that could not run or remain unresolved.
- `no-mistakes` is optional. Use it only when the user or repository explicitly requests it; do not require or
  initialize it for ordinary validation, pushes, or pull requests.
- Complete the requested delivery destination after validation. An explicit request to land on `main` includes that
  final integration; creating a review branch for the gate is an intermediate step.

## Large Changes and Stacks

When a change exceeds the size guidance in `~/.agents/instructions/workflow.md`, split it. Send independent parts as
separate pull requests against the base branch. Stack only the parts that depend on each other:

- Order layers from foundation to consumers, for example types or schema, then logic or API, then wiring, then UI.
  Give each layer one concern.
- Target each pull request at the branch of the layer below it. Each layer must build and pass its checks, and must
  leave the base branch working when it merges in order. Gate or leave unwired any behavior that is not complete yet.
- In each description, give the layer's position (for example, "2 of 4"), link the other layers, and say what to
  review in this layer.
- Use the repository's stacking tool when one is configured, such as `gh stack`, Graphite, or Sapling. Otherwise use
  plain branches. After a lower layer changes or merges, rebase the layers above it and retarget them. Merge from the
  bottom up.
- When the user asked for one pull request, say why you split it.

## Verification Evidence

The PR description includes a **Verification** section that lets a reviewer check each claim without rerunning it.
Build it from the verification contract, and scale it to the risk: a typo fix needs only the check that ran.

- Map each acceptance criterion to its evidence: the command, a trimmed result, and the CI run. For a bug fix or new
  behavior, name the test that failed before the change and passes after it.
- For behavior a person can see or run, include evidence from the running system, not only tests. Use screenshots for
  UI states: before and after when appearance changed, and at desktop and mobile sizes when layout changed. Use a short
  recording for multi-step interactions or motion. Use a terminal transcript for CLI changes, and a request with its
  response for API changes.
- Say where the evidence was captured (local, preview deployment, or staging) and from which commit. Capture it again
  after any later change that affects what it shows.
- Use test or seeded data. Do not show secrets, tokens, or personal data.
- Attach images and recordings through the harness or a path the repository supports, such as a preview deployment or
  CI artifacts. Do not commit them unless the repository already tracks visual baselines. If you cannot attach them,
  give the user their local paths and say that the description does not include them.
- State what was not verified and why. "Tests pass" does not replace evidence that the change works.

Use the risk levels in `~/.agents/instructions/workflow.md` for the title's risk tag.
