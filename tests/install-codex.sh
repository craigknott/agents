#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)

if [ -n "${TEST_ROOT:-}" ]; then
  test_root=${TEST_ROOT}
  mkdir -p "${test_root}"
else
  test_root=$(mktemp -d "${TMPDIR:-/tmp}/install-codex-test.XXXXXX")
  trap 'rm -rf "${test_root}"' EXIT HUP INT TERM
fi

codex_loader='Read and follow `~/.agents/codex/AGENTS.md` for Codex-specific subagent routing and context rules.'

test "$(grep -Fxc 'multi_agent_v2 = false' "${repo_root}/README.md")" -eq 1
test "$(grep -Fxc '@~/.agents/AGENTS.md' "${repo_root}/codex/AGENTS.md")" -eq 1
test "$(grep -Fxc '@~/.codex/RTK.md' "${repo_root}/codex/AGENTS.md")" -eq 1
test "$(grep -Ec '^@' "${repo_root}/codex/AGENTS.md")" -eq 2
test "$(grep -Fxc '@~/.agents/instructions/research.md' "${repo_root}/codex/AGENTS.md")" -eq 0
test "$(grep -Fxc '@~/.agents/instructions/subagents.md' "${repo_root}/codex/AGENTS.md")" -eq 0
grep -Fq 'Ordinary delegations must use `fork_turns="none"`' "${repo_root}/codex/AGENTS.md"
test "$(grep -Ec '^\| [^|]+ \| `(explorer|worker|docs_researcher|bulk_scout|reviewer)` \|' "${repo_root}/codex/AGENTS.md")" -eq 5
test "$(grep -Ec 'gpt-6-astra' "${repo_root}/codex/AGENTS.md")" -ge 5
test "$(grep -Ec '^\| [^|]+ \| `(explorer_sol|worker_sol|reviewer_sol)` \| `gpt-6\.1-sol` \|' "${repo_root}/codex/AGENTS.md")" -eq 3
test "$(grep -Ec 'fork_turns|gpt-[0-9]|`(explorer|worker|docs_researcher|bulk_scout|reviewer)`' "${repo_root}/instructions/subagents.md")" -eq 0

for agent_name in explorer_sol worker_sol reviewer_sol; do
  agent_file="${repo_root}/codex/agents/${agent_name}.toml"
  grep -Fqx "name = \"${agent_name}\"" "${agent_file}"
  grep -Fqx 'model = "gpt-6.1-sol"' "${agent_file}"
  case ${agent_name} in
    reviewer_sol) effort=high ;;
    *) effort=medium ;;
  esac
  grep -Fqx "model_reasoning_effort = \"${effort}\"" "${agent_file}"
done

set -- \
  "${repo_root}/codex/AGENTS.md" \
  "${repo_root}"/codex/agents/*.toml \
  "${repo_root}/scripts/install-codex.sh"

if grep -En '/Users/|/home/|[A-Za-z]:\\Users\\' "$@"; then
  printf '%s\n' 'Machine-local path found in portable Codex files' >&2
  exit 1
fi

if grep -En 'sk-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|://[^/@[:space:]]+:[^/@[:space:]]+@' "$@"; then
  printf '%s\n' 'Possible secret found in portable Codex files' >&2
  exit 1
fi

fallback_home="${test_root}/fallback-home"
mkdir -p "${fallback_home}/agents"
printf '%s\n' 'name = "unrelated-fallback"' >"${fallback_home}/agents/unrelated.toml"
printf '%s\n' '# Keep this fallback instruction.' >"${fallback_home}/AGENTS.md"
: >"${fallback_home}/AGENTS.override.md"
printf '%s\n' 'model = "fallback-sentinel"' >"${fallback_home}/config.toml"

fallback_config_before=$(cksum "${fallback_home}/config.toml")
fallback_unrelated_before=$(cksum "${fallback_home}/agents/unrelated.toml")
fallback_override_before=$(cksum "${fallback_home}/AGENTS.override.md")

CODEX_HOME="${fallback_home}" "${repo_root}/scripts/install-codex.sh" >"${test_root}/fallback-first.txt"

for agent_file in "${repo_root}"/codex/agents/*.toml; do
  cmp "${agent_file}" "${fallback_home}/agents/${agent_file##*/}"
done
grep -Fq 'Installed 8 Codex agents in ' "${test_root}/fallback-first.txt"

grep -Fq '# Keep this fallback instruction.' "${fallback_home}/AGENTS.md"
test "$(grep -Fxc "${codex_loader}" "${fallback_home}/AGENTS.md")" -eq 1
test "$(cksum "${fallback_home}/AGENTS.override.md")" = "${fallback_override_before}"
test "$(cksum "${fallback_home}/config.toml")" = "${fallback_config_before}"
test "$(cksum "${fallback_home}/agents/unrelated.toml")" = "${fallback_unrelated_before}"

fallback_state_before_repeat=$(find "${fallback_home}" -type f -exec cksum {} \; | LC_ALL=C sort)
CODEX_HOME="${fallback_home}" "${repo_root}/scripts/install-codex.sh" >"${test_root}/fallback-second.txt"
fallback_state_after_repeat=$(find "${fallback_home}" -type f -exec cksum {} \; | LC_ALL=C sort)

test "${fallback_state_after_repeat}" = "${fallback_state_before_repeat}"
test "$(grep -Fxc "${codex_loader}" "${fallback_home}/AGENTS.md")" -eq 1

override_home="${test_root}/override-home"
mkdir -p "${override_home}/agents"
printf '%s\n' 'name = "unrelated-override"' >"${override_home}/agents/unrelated.toml"
printf '%s\n' '# Keep this inactive instruction.' >"${override_home}/AGENTS.md"
printf '%s\n' '# Keep this active override.' >"${override_home}/AGENTS.override.md"
printf '%s\n' 'model = "override-sentinel"' >"${override_home}/config.toml"

override_config_before=$(cksum "${override_home}/config.toml")
override_unrelated_before=$(cksum "${override_home}/agents/unrelated.toml")
override_agents_before=$(cksum "${override_home}/AGENTS.md")

CODEX_HOME="${override_home}" "${repo_root}/scripts/install-codex.sh" >"${test_root}/override-first.txt"

for agent_file in "${repo_root}"/codex/agents/*.toml; do
  cmp "${agent_file}" "${override_home}/agents/${agent_file##*/}"
done

grep -Fq '# Keep this active override.' "${override_home}/AGENTS.override.md"
test "$(grep -Fxc "${codex_loader}" "${override_home}/AGENTS.override.md")" -eq 1
test "$(cksum "${override_home}/AGENTS.md")" = "${override_agents_before}"
test "$(cksum "${override_home}/config.toml")" = "${override_config_before}"
test "$(cksum "${override_home}/agents/unrelated.toml")" = "${override_unrelated_before}"

override_state_before_repeat=$(find "${override_home}" -type f -exec cksum {} \; | LC_ALL=C sort)
CODEX_HOME="${override_home}" "${repo_root}/scripts/install-codex.sh" >"${test_root}/override-second.txt"
override_state_after_repeat=$(find "${override_home}" -type f -exec cksum {} \; | LC_ALL=C sort)

test "${override_state_after_repeat}" = "${override_state_before_repeat}"
test "$(grep -Fxc "${codex_loader}" "${override_home}/AGENTS.override.md")" -eq 1

default_home="${test_root}/default-user-home"
mkdir -p "${default_home}"

(
  unset CODEX_HOME
  HOME="${default_home}" "${repo_root}/scripts/install-codex.sh"
) >"${test_root}/default-first.txt"

default_codex_home="${default_home}/.codex"
for agent_file in "${repo_root}"/codex/agents/*.toml; do
  cmp "${agent_file}" "${default_codex_home}/agents/${agent_file##*/}"
done

test "$(grep -Fxc "${codex_loader}" "${default_codex_home}/AGENTS.md")" -eq 1
test ! -e "${default_codex_home}/config.toml"

default_state_before_repeat=$(find "${default_codex_home}" -type f -exec cksum {} \; | LC_ALL=C sort)
(
  unset CODEX_HOME
  HOME="${default_home}" "${repo_root}/scripts/install-codex.sh"
) >"${test_root}/default-second.txt"
default_state_after_repeat=$(find "${default_codex_home}" -type f -exec cksum {} \; | LC_ALL=C sort)

test "${default_state_after_repeat}" = "${default_state_before_repeat}"

printf '%s\n' 'Installer checks passed for the default home, AGENTS.md fallback, and AGENTS.override.md precedence.'
