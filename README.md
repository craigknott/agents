# Agents

Personal, cross-repository instructions for coding agents.

`AGENTS.md` and its referenced topic files are the source of truth for these cross-agent preferences. Tool-specific
instruction files should stay as thin forwarders so the same guidance is loaded everywhere without copying it.

## Astra defaults

These instructions apply the
[Astra prompting guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra) through the
shared [workflow guidance](instructions/workflow.md) and [delegation preference](instructions/subagents.md).

The routing configured in [Setup](#setup) is a workload policy, not a benchmark result. Compare task outcomes, latency,
and usage before retuning effort or routing. Preserve the primary agent's effective effort during migration.

## Setup

Clone this repository into `~/.agents`:

```sh
git clone git@github.com:craigknott/agents.git ~/.agents
```

Install `no-mistakes` and make sure the `no-mistakes` binary is on your `PATH`:

```sh
go install github.com/kunchenguid/no-mistakes/cmd/no-mistakes@latest
```

If the command is not found after installation, add Go's binary directory to your shell `PATH`:

```sh
export PATH="$(go env GOPATH)/bin:$PATH"
```

Persist that line in your shell startup file, such as `~/.zshrc`, when needed.

Initialize `no-mistakes` only in repositories where you want to use its validation gate:

```sh
no-mistakes init
```

The agent defaults make this the canonical gate for requested Git pushes, pull-request delivery, and explicit validation
unless the user or repository specifies another workflow; ordinary repository work does not trigger initialization.

`no-mistakes init` also installs the `/no-mistakes` agent skill. From a supported coding agent, you can gate a task
directly:

```text
/no-mistakes add a --json flag to the status command
```

Or validate already committed branch work:

```text
/no-mistakes
```

Install the shared Codex subagent definitions and instruction forwarders:

```sh
~/.agents/scripts/install-codex.sh
```

The installer uses `$CODEX_HOME` when set and otherwise defaults to `~/.codex`. It copies these portable definitions
into that Codex home's `agents/` directory:

- [explorer](codex/agents/explorer.toml)
- [worker](codex/agents/worker.toml)
- [docs_researcher](codex/agents/docs_researcher.toml)
- [bulk_scout](codex/agents/bulk_scout.toml)
- [reviewer](codex/agents/reviewer.toml)

It preserves other files in `agents/` and follows Codex's global instruction precedence: when the selected home has a
non-empty `AGENTS.override.md`, it updates the loader there; otherwise it preserves or creates `AGENTS.md`. In that
active file, it removes the exact legacy loader line describing subagent routing and context rules, then adds the short
loader if missing, preserving other instructions. Repeated installation leaves the result unchanged.

The installed directive loads [codex/AGENTS.md](codex/AGENTS.md), the thin forwarder. The `.agents` installer does not
install RTK and does not read or modify `config.toml` in that Codex home. Remove the RTK include from the forwarder if
that optional tool is not installed. The pack contains no credentials. Configure Context7 separately
in your own Codex configuration if `docs_researcher` should use it; the agent inherits that server configuration.

To reproduce this setup's model defaults and six-child concurrency ceiling, merge the following settings into the
selected Codex home's `config.toml` (normally `~/.codex/config.toml`). Put root model keys before any table, and update
existing keys and tables instead of duplicating them. The
[Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference) defines these settings.

```toml
model = "gpt-6-astra"
model_reasoning_effort = "xhigh"

[agents]
enabled = true
max_concurrent_threads_per_session = 6
default_subagent_model = "gpt-6-astra"
default_subagent_reasoning_effort = "medium"
interrupt_message = true

[features]
multi_agent = true
multi_agent_v2 = false
```

The configuration example above owns this setup's primary and default-child settings; the linked role TOML files own
each role's model, effort, description, permissions, and responsibilities. Parent guidance lives in
[instructions/subagents.md](instructions/subagents.md).

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
- `codex/AGENTS.md` - thin forwarder to the global instructions and installed RTK guidance.
- `codex/agents/` - portable custom-agent definitions installed into the selected Codex home's `agents/` directory.
- `instructions/` - focused guidance loaded only when the task matches the topic.
- `scripts/install-codex.sh` - idempotent Codex agent and instruction-forwarder installer.

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

Confirm that Codex can discover the shared roles:

```sh
ls ~/.codex/agents/{explorer,worker,docs_researcher,bulk_scout,reviewer}.toml
```

Check that `no-mistakes` prerequisites are available:

```sh
no-mistakes doctor
```

Run the installer regression checks after changing the portable pack:

```sh
sh -n scripts/install-codex.sh
sh -n tests/install-codex.sh
sh tests/install-codex.sh
git diff --check
```

These check installation, repeatability, and preservation of existing configuration; they do not evaluate how a model
interprets the instructions.

After changes are pushed, update another machine with:

```sh
git -C ~/.agents pull --ff-only
```
