Use when exploring, changing, or validating a repository.

## Repository Evidence

- Inspect the nearest repository instructions, manifests and lockfiles, scripts, CI, test configuration, and nearby code
  relevant to the task.
- Follow established architecture, naming, ownership, and error-handling patterns.
- Keep a repository's agent instructions in `AGENTS.md`, which both Claude Code and Codex read natively. Do not add a
  `CLAUDE.md` or `CLAUDE.local.md` beside it: either one stops Claude Code from reading `AGENTS.md` by default. When a
  repository already has both, propose merging them into `AGENTS.md`.

## Verification Contract

Before editing on any non-trivial task, define this contract and keep it current. Keep it in your working plan and
in delegated briefs, not in these instruction files.

1. **Done when:** observable acceptance criteria, each tied to one check.
2. **Oracle:** the command or observation that proves each criterion. Prefer, in order: an existing or new failing
   test; the real consumer (run the CLI, call the endpoint, render the page); a typed parse or schema check; recorded
   manual inspection. Reading the code is not an oracle.
3. **Baseline:** run the checks before changing anything. Record failures that already exist so they are not mistaken
   for regressions.
4. **Red first:** for bugs and new behavior, show the check failing before the fix when practical. When you add a
   check, confirm it can fail.
5. **Loop:** edit, run the narrowest check, then run the full required checks at the end. If one check fails three
   times after different fixes, stop patching and re-diagnose the cause.
6. **Independent check:** for medium or high risk, ask a reviewer from the other model family to check the request,
   the contract, and the diff. Follow `~/.agents/instructions/delegation.md`.
7. **Report:** give each criterion with its evidence (command and result, or a screenshot or recording of the running
   system), and state what stayed unverified. For a pull request, put this evidence in its description as
   `~/.agents/instructions/git-and-pr.md` describes.

If no oracle exists, say so before you start. Build the smallest one that works, or ask. If the repository has no
documented verification command, take it from CI or the manifests and propose a `## Verify` section for its
`AGENTS.md`.

## Backward Compatibility

- Preserve existing public contracts unless the requested outcome requires changing them. Infer routine compatibility
  choices from the task, callers, tests, and repository conventions.
- Clarify only an unresolved compatibility choice that materially changes the result; continue independent work while
  it is unresolved. Apply the decision consistently to implementation, tests, documentation, and rollout.

## Design and Implementation

- Reuse canonical definitions and existing abstractions. Generalize only for concrete reuse; avoid duplicate paths,
  speculative indirection, and mechanical fragmentation.
- Keep domain logic and control flow direct. Separate responsibilities when it improves cohesion, understanding, or
  testing.
- Follow the repository's language- and framework-specific style, formatter, linter, and idioms. When local guidance is
  absent, follow the language's official or broadly accepted conventions.
- Keep the diff focused and prefer the underlying fix over a duplicate path, workaround, or unrelated refactor.

## Reviewability and Readability

- Treat reviewability as part of correctness. Shape work as the smallest coherent slice that delivers understandable,
  testable behavior; do not use one-shot completion to justify a diff that is too broad to review confidently.
- Use size as a trigger to split, not as a hard limit. Aim for about 200 changed lines of reviewable code per pull
  request, and split or explain the coupling above about 400. Count hand-written code and tests. Exclude generated
  files, lockfiles, snapshots, vendored code, pure deletions, and mechanical changes from a trusted tool, and say how
  those were produced. A change spread across many unrelated files is too large even when its line count is small.
- When a change is likely to exceed that size, plan the slices before editing and put them in the verification
  contract. Splitting a finished diff afterwards is harder and tends to leave layers that cannot be tested alone.
- Separate independent refactors, dependency or generated-file churn, migrations, and behavior changes when practical.
  If a change cannot be divided safely, explain the coupling and give reviewers a clear path through it.
- Optimize code for the next reader: use names that convey intent, keep control flow direct, keep responsibilities
  cohesive, and document non-obvious reasons or invariants rather than restating the code.
- Do not sacrifice clarity merely to reduce line count or diff size.

## Feature Gates

- Use the repository's existing feature-gate system when new behavior needs staged rollout or independent operational
  control. Avoid adding a gate to a routine fix without a rollout need, or introducing a parallel flag system.
- Test enabled and disabled paths, choose the default according to the compatibility and rollout decisions, and define
  when temporary gates and old paths will be removed.

## Completion and Validation

- Deliver the complete requested behavior, including necessary wiring, edge cases, cleanup, tests, and documentation.
  Do not stop at scaffolding, a partial code path, or avoidable TODOs when the remaining work is in scope and feasible.
- Add or update tests for meaningful behavior changes and regressions. For low-impact documentation, configuration,
  or cosmetic changes, prefer the relevant parser, linter, existing checks, or visual inspection. Do not add tests that
  merely match implementation text or restate instructions.
- For bug fixes, reproduce the failure with a test, command, or clear code-path explanation before changing behavior
  when practical.
- Run the narrowest relevant checks and all required repository checks. Broaden or repeat only for new changes,
  failures, or a concrete unresolved risk; passing checks should lead to delivery.
- Inspect the final diff for unrelated churn, debugging residue, accidental local paths, and test coverage of the
  changed behavior.
- Report against the verification contract: the commands that ran, their outcomes, and any validation that remains
  unavailable.
