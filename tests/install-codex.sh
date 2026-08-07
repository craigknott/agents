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
test "$(grep -Fxc '@~/.agents/codex/RTK.md' "${repo_root}/codex/AGENTS.md")" -eq 1
test "$(grep -Fxc '@~/.agents/instructions/research.md' "${repo_root}/codex/AGENTS.md")" -eq 1
test "$(grep -Fxc '@~/.agents/instructions/subagents.md' "${repo_root}/codex/AGENTS.md")" -eq 1
grep -Fq 'Always prefix shell commands with `rtk`.' "${repo_root}/codex/RTK.md"
grep -Fq 'use Context7 when available' "${repo_root}/instructions/research.md"
grep -Fq 'Ordinary delegations must use `fork_turns="none"`' "${repo_root}/codex/AGENTS.md"
test "$(grep -Ec '^\| [^|]+ \| `(explorer|worker|docs_researcher|bulk_scout|reviewer)` \|' "${repo_root}/codex/AGENTS.md")" -eq 5
test "$(grep -Ec 'gpt-5\.6-(sol|terra)' "${repo_root}/codex/AGENTS.md")" -ge 5
test "$(grep -Ec 'fork_turns|gpt-5\.6-|`(explorer|worker|docs_researcher|bulk_scout|reviewer)`' "${repo_root}/instructions/subagents.md")" -eq 0

portable_files="${repo_root}/codex/AGENTS.md ${repo_root}/codex/RTK.md ${repo_root}/codex/agents/explorer.toml ${repo_root}/codex/agents/worker.toml ${repo_root}/codex/agents/docs_researcher.toml ${repo_root}/codex/agents/bulk_scout.toml ${repo_root}/codex/agents/reviewer.toml ${repo_root}/scripts/install-codex.sh"

if grep -En '/Users/|/home/|[A-Za-z]:\\Users\\' ${portable_files}; then
  printf '%s\n' 'Machine-local path found in portable Codex files' >&2
  exit 1
fi

if grep -En 'sk-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|://[^/@[:space:]]+:[^/@[:space:]]+@' ${portable_files}; then
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

for agent_name in explorer worker docs_researcher bulk_scout reviewer; do
  cmp "${repo_root}/codex/agents/${agent_name}.toml" "${fallback_home}/agents/${agent_name}.toml"
done

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

for agent_name in explorer worker docs_researcher bulk_scout reviewer; do
  cmp "${repo_root}/codex/agents/${agent_name}.toml" "${override_home}/agents/${agent_name}.toml"
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
for agent_name in explorer worker docs_researcher bulk_scout reviewer; do
  cmp "${repo_root}/codex/agents/${agent_name}.toml" "${default_codex_home}/agents/${agent_name}.toml"
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
