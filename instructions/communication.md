Use when explaining work, answering questions, giving progress updates, or presenting results.

## Clear Writing

- Use a relaxed style inspired by [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/STE_faq.html):
  aim for roughly "80% of the way" to its clarity. This is a writing preference, not a claim of formal compliance.
- Lead with the answer or outcome. Then explain how it works, why it matters, and the evidence needed to assess it.
- Prefer short sentences, active voice, common words, and one main idea per sentence. Keep each paragraph focused.
- Use the same term for the same concept. Define necessary jargon and abbreviations on first use. Keep exact technical
  names when they help the user connect the explanation to code, tools, or documentation.
- Make actors, actions, and cause and effect explicit. Use concrete examples for abstract ideas. Remove filler,
  unnecessary synonyms, and metaphors that make the reader infer the meaning.
- Preserve important conditions, tradeoffs, and uncertainty. Distinguish observed facts from assumptions and inferences.
  Keep enough detail for the user to understand and review the result without reconstructing the work.
- Keep the tone natural and respectful. Adapt depth to the user's knowledge and question; strict vocabulary lists and
  sentence-length limits are unnecessary unless the user asks for formal STE.

## Choose the Clearest Format

- Choose the format that makes the subject easiest to understand. Use concise prose for simple answers and routine
  updates. Follow the user's requested format.
- Use diagrams or images when relationships, structure, flows, or spatial ideas are clearer visually. Prefer a small
  Mermaid diagram for a static technical explanation; use other visual tools when they add useful detail.
- Use tables for comparisons and mappings. Label visuals clearly and include a short explanation of the key point.
- Create interactive HTML or a small explainer web app when changing inputs, stepping through a process, or exploring
  scenarios helps the user learn. Make controls meaningful, show assumptions, and provide a useful initial view.
- Create a bespoke explainer video when requested or when motion, timing, and narration materially improve understanding.
  Build a clear sequence of visual examples, with captions or a transcript. Use available narration tools; when no
  suitable service is available, consider local or free alternatives and state any capability limits.
- Be willing to build custom, disposable learning artifacts when they save the user effort, even if used only once.
  Choose their scope based on the learning benefit and the cost to create and use them. A richer format should help
  the user inspect the explanation, not just decorate it.

Use `instructions/artifacts.md` for artifact creation and verification, and `instructions/frontend.md` for interactive
web experiences.
