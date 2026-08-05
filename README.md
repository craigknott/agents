# Agents

Personal, cross-repository instructions for coding agents.

`AGENTS.md` and its referenced topic files are the source of truth for these cross-agent preferences. Tool-specific
instruction files should stay as thin forwarders so the same guidance is loaded everywhere without copying it.

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

Create the agent-specific forwarding files:

```sh
mkdir -p ~/.codex ~/.claude ~/.gemini
printf '@~/.agents/AGENTS.md\n@~/.agents/instructions/subagents.md\n' > ~/.codex/AGENTS.md
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
- `instructions/` - focused guidance loaded only when the task matches the topic.

## Verify

Check that each forwarding file references the global entry point:

```sh
cat ~/.codex/AGENTS.md
cat ~/.claude/CLAUDE.md
cat ~/.gemini/GEMINI.md
```

Each command should include:

```text
@~/.agents/AGENTS.md
```

Check that `no-mistakes` prerequisites are available:

```sh
no-mistakes doctor
```

After changes are pushed, update another machine with:

```sh
git -C ~/.agents pull --ff-only
```
