Use when branching, staging, committing, pushing, creating pull requests, or addressing PR feedback.

- Follow repository conventions, keep commits focused, and stage only files that belong to the requested change.
- Follow the repository's PR template and naming rules. When none exist, use
  `<ISSUEID|NOISSUE> - [<low|medium|high>] - <Title>`.
- A fallback PR description should cover context, the change, validation, risk, and rollback.
- For requested pushes, use `no-mistakes` by default unless the user or repository specifies another workflow. Follow
  its installed skill or repository documentation, and initialize it only when needed for that push—not when unrelated
  work begins.

Use `instructions/code-review.md` for risk classification.
