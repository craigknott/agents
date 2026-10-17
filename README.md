# Agents

Personal, cross-repository instructions for coding agents.

`AGENTS.md` and its referenced topic files are the source of truth for these cross-agent preferences. Tool-specific
instruction files should stay as thin forwarders so the same guidance is loaded everywhere without copying it.

## Setup

Clone this repository into `~/.agents`:

```sh
git clone git@github.com:craigknott/agents.git ~/.agents
```

Install the shared Codex subagent definitions and instruction forwarders:

```sh
~/.agents/scripts/install-codex.sh
```

The installer uses `$CODEX_HOME` when set and otherwise defaults to `~/.codex`. It copies these portable definitions
into that Codex home's `agents/` directory:

| Agent | Purpose | Default configuration |
| --- | --- | --- |
| `explorer` | Targeted repository exploration | Read-only; inherits the configured child model and effort |
| `worker` | Bounded implementation and verification | Workspace-write; inherits the configured child model and effort |
| `docs_researcher` | OpenAI Docs and optional Context7 research | `gpt-6-astra`, medium, read-only |
| `bulk_scout` | Large-file, log, or repository-partition scans | `gpt-6-astra`, medium, read-only |
| `reviewer` | Correctness, security, regression, and test review | `gpt-6-astra`, high, read-only |

It preserves other files in `agents/` and follows Codex's global instruction precedence: when the selected home has a
non-empty `AGENTS.override.md`, it appends missing loader directives there; otherwise it preserves or creates
`AGENTS.md`. The installed directive loads `~/.agents/codex/AGENTS.md`, whose opening references mirror a normal Codex
forwarder: `~/.agents/AGENTS.md` and the RTK installation's `~/.codex/RTK.md`, followed by the Codex-specific routing
rules. The `.agents` installer does not install RTK and does not read or modify `config.toml` in that Codex home. Remove
the RTK include if that optional tool is not installed. The pack contains no credentials. Configure Context7 separately
in your own Codex configuration if `docs_researcher` should use it; the agent inherits that server configuration.

Current Codex releases enable subagents by default. To reproduce this repository's bounded child defaults and
three-child cap, merge the following settings into the selected Codex home's `config.toml` (normally
`~/.codex/config.toml`) without duplicating an existing table:

```toml
[agents]
enabled = true
max_concurrent_threads_per_session = 3
default_subagent_model = "gpt-6-astra"
default_subagent_reasoning_effort = "medium"
interrupt_message = true

[features]
multi_agent = true
multi_agent_v2 = false
```

`fork_turns` is selected at spawn time rather than in `config.toml`. The Codex-specific instructions direct agents to
pass `fork_turns="none"` for ordinary delegation and provide a self-contained task capsule.

For other agent tools, create their forwarding files separately:

```sh
mkdir -p ~/.claude ~/.gemini
printf '@~/.agents/AGENTS.md\n' > ~/.claude/CLAUDE.md
printf '@~/.agents/AGENTS.md\n' > ~/.gemini/GEMINI.md
```

Add guidance that a tool must always load as another include rather than copying shared rules into the forwarding file.

Use the same pattern for any other agent tool that supports `@` includes:

```sh
printf '@~/.agents/AGENTS.md\n' > /path/to/tool/instructions-file.md
```

## Repository Files

- `AGENTS.md` - global entry point and router for topic-specific instructions.
- `codex/AGENTS.md` - global and installed-RTK references plus Codex-specific role routing and bounded-context guidance.
- `codex/agents/` - portable custom-agent definitions installed into the selected Codex home's `agents/` directory.
- `instructions/` - focused guidance loaded only when the task matches the topic.
- `scripts/install-codex.sh` - idempotent Codex agent and instruction-forwarder installer.

The [communication guide](instructions/communication.md) sets a plain-language default inspired by ASD-STE100 and
encourages diagrams, interactive HTML, and explainer videos when they make results easier to understand. The
[delivery guide](instructions/git-and-pr.md) uses each repository's existing checks and workflow for validation,
pushes, and pull requests.

## Verify

With the default Codex home, inspect the active Codex global instruction file and the other forwarding files:

```sh
if [ -s ~/.codex/AGENTS.override.md ]; then
  cat ~/.codex/AGENTS.override.md
else
  cat ~/.codex/AGENTS.md
fi
cat ~/.claude/CLAUDE.md
cat ~/.gemini/GEMINI.md
```

The Codex active file should load:

```text
~/.agents/codex/AGENTS.md
```

That file begins with references to `~/.agents/AGENTS.md` and the optional installed `~/.codex/RTK.md`, then directs
ordinary Codex delegations to use `fork_turns="none"`. Research and general delegation guidance remain routed through
the shared `~/.agents/AGENTS.md` entry point instead of being referenced again here.

Confirm that Codex can discover the shared roles:

```sh
ls ~/.codex/agents/{explorer,worker,docs_researcher,bulk_scout,reviewer}.toml
```

After changes are pushed, update another machine with:

```sh
git -C ~/.agents pull --ff-only
```
