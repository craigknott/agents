Use this file before selecting specialized skills, MCP tools, browser automation, generated images, OpenAI docs,
Context7, or other task-specific tools.

# Tool Selection

- Prefer the narrowest tool or skill that directly fits the task.
- Prefer read-only and search-oriented tools before write-capable tools.
- Use repository evidence before external tools when the answer should be in the codebase.
- For shell search, prefer `rg` and `rg --files`; fall back only when unavailable.
- Parallelize independent file reads and searches when the available tooling supports it.
- Do not claim a tool, connector, or skill was used unless it exists in the current environment and was actually used.

# Preferred Skills

Use these skills when they fit the task and are available:

- `playwright-cli` for terminal-first browser automation and visual QA
- `imagegen` for bitmap asset generation or image editing
- `openai-docs` for OpenAI API, model, SDK, and Codex questions
- Context7 for third-party library and framework documentation
- Figma skills for design-to-code and Figma file operations when available
- `create-pr` for opening or refreshing pull requests that follow Atlassian conventions
- `mitigating-vuln` and `trivy-security-scan` for vulnerability and container security work
- Google Drive, Docs, Sheets, and Slides skills when source material or deliverables live in Drive
- Slack skills for reading Slack context or drafting outbound Slack messages

# Skill Maintenance

- If a workflow keeps recurring and there is no skill for it yet, recommend creating one instead of expanding the global
  instructions indefinitely.
- If a named skill is missing or blocked, say so briefly and continue with the best available fallback.
- When a preferred tool is unavailable, use the closest safe fallback and name any confidence or freshness limits.
