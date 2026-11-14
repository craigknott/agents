# Agents

Personal, cross-repository instructions for coding agents in Claude Code and Codex.

`AGENTS.md` and its referenced topic files are the source of truth for these cross-agent preferences. Tool-specific
instruction files stay as thin forwarders so the same guidance is loaded everywhere without copying it. Harness-specific
orchestration, such as T3 Code's delegation tools, stays in that harness's own configuration.

The two most important topics are:

- [Verification contract](instructions/workflow.md#verification-contract) — define done, the oracle, and the baseline
  before editing, so agents can work and check themselves unattended.
- [Delegation](instructions/delegation.md) — role routing across Claude and Codex models, and cross-provider review.

The routing is a workload policy, not a benchmark result. Compare task outcomes, latency, and usage before retuning
effort or routing.

## Setup

Clone this repository into `~/.agents` and run the installer:

```sh
git clone git@github.com:craigknott/agents.git ~/.agents
~/.agents/scripts/install.sh
```

`install.sh` runs both tool installers. Each is idempotent, preserves unrelated files, and contains no credentials.
Before replacing a role file that differs from this pack's version, or removing a retired one, an installer moves it to
`backups/agents-pack/` in that tool's home under a timestamped name.

**Codex** (`scripts/install-codex.sh`) uses `$CODEX_HOME` or `~/.codex`. It:

- copies the role files from [codex/agents](codex/agents) into `agents/` and removes retired roles from this pack;
- adds a loader line for the thin forwarder [codex/AGENTS.md](codex/AGENTS.md) to the active global instruction file.
  That is `AGENTS.override.md` when it is non-empty, otherwise `AGENTS.md`. It also removes the legacy loader line.

It does not read or modify `config.toml`. The forwarder also includes `~/.codex/RTK.md`; remove that line if RTK is
not installed. Configure Context7 in your own Codex config if `docs_researcher` should use it.

**Claude Code** (`scripts/install-claude.sh`) uses `$CLAUDE_CONFIG_DIR` or `~/.claude`. It:

- copies the role files from [claude/agents](claude/agents) into `agents/`;
- links each shared skill in [skills](skills) into `skills/`, keeping any existing entry of the same name, and removes
  links to shared skills that no longer exist;
- adds `@~/.agents/AGENTS.md` to the user `CLAUDE.md`.

Claude Code reads a repository's `AGENTS.md` natively, but not anything under `~/.agents`, so the user import is still
needed for these global instructions.

### Skills

`skills/` is the one home for shared skills in the open Agent Skills format. Codex reads `~/.agents/skills` natively as
its user skills folder; the Claude installer links each skill into `~/.claude/skills`. When a third-party tool installs
and updates a skill there, list it in `.gitignore` so that only skills authored here are tracked.

### Roles

| Role | Claude | Codex | Writes |
|---|---|---|---|
| `scout` | Haiku | `gpt-6-luna` medium | no |
| `explorer` | Sonnet medium | `gpt-6.1-sol` medium | no |
| `worker` | Sonnet medium | `gpt-6.1-sol` medium | yes |
| `reviewer` | Opus high | `gpt-6.1-sol` high | no |
| `deep_reviewer` | Fable high | `gpt-6-astra` high | no |
| `docs_researcher` | — | `gpt-6.1-sol` medium | no |

Role files pin model and effort independently of the configured child defaults. Native subagents inherit the parent
session's permissions. Codex enforces read-only roles with its sandbox. Native Claude read-only roles block the edit
tools but keep Bash so reviewers can rerun checks.

### Cross-provider delegation

This pack ships no cross-provider tooling. Agents reach the other provider through the active harness's own delegation
mechanism, such as T3 Code's. [instructions/delegation.md](instructions/delegation.md#cross-provider-review) says when
a cross-provider review is needed and what its brief must contain. In a harness without such a mechanism, agents use a
same-provider reviewer and say so in the report.

### Codex config

To reproduce this setup's model defaults and six-child concurrency ceiling, merge these settings into the Codex home's
`config.toml`. Put root keys before any table, and update existing keys instead of duplicating them. The
[Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference) defines them.

```toml
model = "gpt-6.1-sol"
model_reasoning_effort = "xhigh"

[agents]
enabled = true
max_concurrent_threads_per_session = 6
default_subagent_model = "gpt-6.1-sol"
default_subagent_reasoning_effort = "medium"

[features]
multi_agent = true
multi_agent_v2 = false
```

### Other tools

For another agent tool that supports `@` includes, point its instruction file at the shared entry point:

```sh
printf '@~/.agents/AGENTS.md\n' > /path/to/tool/instructions-file.md
```

## Repository Files

- `AGENTS.md` — global entry point and router for topic-specific instructions.
- `instructions/` — focused guidance loaded only when the task matches the topic.
- `codex/AGENTS.md`, `codex/agents/` — Codex forwarder and role definitions.
- `claude/agents/` — Claude Code role definitions.
- `skills/` — shared skills, read by Codex directly and linked into Claude Code.
- `scripts/` — installers and their shared helpers.
- `tests/` — checks for the installers, pinned models, role parity, and the routing tables.
- `tests/behavior/` — scenario prompts that show how a real agent reads the instructions. They call a model, so they
  run only when you ask.

## Verify

Run the checks after changing the pack:

```sh
for f in scripts/*.sh tests/*.sh tests/behavior/*.sh; do sh -n "$f"; done
for t in tests/*.sh; do sh "$t"; done
git diff --check
```

`tests/models.sh` checks that every pinned Codex model is offered by the local Codex CLI (`models_cache.json`), and that
Claude models are valid aliases or IDs. `tests/role-parity.sh` checks that each shared role has the same name and
instructions on both platforms. `tests/routing-tables.sh` checks that the routing tables in this file and in
`instructions/delegation.md` show the model and effort that each role file pins. The other tests check the installers.
None of these checks shows how a model interprets the instructions.

To see that, run the scenario prompts after you change how agents handle a request:

```sh
sh tests/behavior/assumptions.sh claude
sh tests/behavior/assumptions.sh codex
```

Each scenario runs one prompt in a throwaway repository with your own CLI configuration. The script checks what the
agent did to the files, and prints the reply for you to read against the stated expectation. The runs call a model and
take a few minutes.

After installing, confirm both tools load the shared instructions and roles:

```sh
cat ~/.claude/CLAUDE.md                 # contains @~/.agents/AGENTS.md
ls ~/.claude/agents ~/.codex/agents
cd /tmp && claude -p "Which topic file covers delegation in your global instructions?"
```

After changes are pushed, update another machine with:

```sh
git -C ~/.agents pull --ff-only && ~/.agents/scripts/install.sh
```
