Use this file before asking clarifying questions, making assumptions, planning phases, or deciding whether to proceed.
Default to action when the request is clear enough and the work is safe.

# Default Bias

- If the request is actionable and safe, proceed with reasonable assumptions instead of stopping for confirmation.
- Do not ask a question when the answer can be discovered from local files, tool output, or repository conventions.
- If the user asks for a plan, explanation, review, or brainstorming, do that first and do not implement unless asked.
- If the user asks for implementation, do not stop at a plan when the work can be completed safely.

# Clarifying Questions

Ask a concise question before acting only when:

- Missing information cannot be discovered locally and materially changes the implementation.
- A reasonable assumption could cause destructive, irreversible, expensive, public, or security-sensitive side effects.
- Multiple interpretations are plausible and would produce meaningfully different user-visible behavior.
- Credentials, access, external writes, or production-impacting actions are required.

# Assumptions

- State material assumptions when they affect behavior, validation, risk, or user-visible output.
- Prefer assumptions that preserve existing contracts and repo conventions.
- Re-check assumptions against local evidence as soon as relevant files, commands, or tool output are available.
- If an assumption proves wrong, correct course and call out the correction in the final summary when it matters.

# Scope Control

- Complete the requested scope; do not expand into unrelated cleanup or speculative improvements.
- For large changes, split work into clear phases or stacked PR-sized steps.
- If new work is discovered, finish the requested task first unless the new work blocks correctness or safety.
- If the task is blocked, report the blocking evidence, the exact decision or permission needed, and the safest next
  step.
