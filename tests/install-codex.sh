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

codex_home="${test_root}/codex-home"
mkdir -p "${codex_home}/agents"

printf '%s\n' 'name = "unrelated"' >"${codex_home}/agents/unrelated.toml"
printf '%s\n' '# Keep this local instruction.' >"${codex_home}/AGENTS.md"
printf '%s\n' 'model = "sentinel-model"' >"${codex_home}/config.toml"

config_before=$(cksum "${codex_home}/config.toml")
unrelated_before=$(cksum "${codex_home}/agents/unrelated.toml")

test "$(grep -Fxc 'multi_agent_v2 = false' "${repo_root}/README.md")" -eq 1
grep -Fq 'Use `fork_turns="none"`' "${repo_root}/instructions/subagents.md"

CODEX_HOME="${codex_home}" "${repo_root}/scripts/install-codex.sh" >"${test_root}/first-install.txt"

for agent_name in explorer worker docs_researcher bulk_scout reviewer; do
  cmp "${repo_root}/codex/agents/${agent_name}.toml" "${codex_home}/agents/${agent_name}.toml"
done

test "$(grep -Fxc 'Read and follow `~/.agents/AGENTS.md` as the global instruction entry point.' "${codex_home}/AGENTS.md")" -eq 1
test "$(grep -Fxc 'Before delegating work, read and follow `~/.agents/instructions/subagents.md`; ordinary delegations use `fork_turns="none"` as specified there.' "${codex_home}/AGENTS.md")" -eq 1
test "$(cksum "${codex_home}/config.toml")" = "${config_before}"
test "$(cksum "${codex_home}/agents/unrelated.toml")" = "${unrelated_before}"

state_before_repeat=$(find "${codex_home}" -type f -exec cksum {} \; | LC_ALL=C sort)
CODEX_HOME="${codex_home}" "${repo_root}/scripts/install-codex.sh" >"${test_root}/second-install.txt"
state_after_repeat=$(find "${codex_home}" -type f -exec cksum {} \; | LC_ALL=C sort)

test "${state_after_repeat}" = "${state_before_repeat}"
test "$(grep -Fxc 'Read and follow `~/.agents/AGENTS.md` as the global instruction entry point.' "${codex_home}/AGENTS.md")" -eq 1
test "$(grep -Fxc 'Before delegating work, read and follow `~/.agents/instructions/subagents.md`; ordinary delegations use `fork_turns="none"` as specified there.' "${codex_home}/AGENTS.md")" -eq 1

report_file="${test_root}/installer-evidence.txt"
{
  printf '%s\n' 'Installer end-to-end checks passed:'
  sed 's/^/  first run: /' "${test_root}/first-install.txt"
  sed 's/^/  second run: /' "${test_root}/second-install.txt"
  printf '%s\n' '  installed roles: explorer, worker, docs_researcher, bulk_scout, reviewer'
  printf '%s\n' '  delegation default: shared instructions require fork_turns="none"'
  printf '%s\n' '  preserved: existing AGENTS.md content, unrelated.toml, config.toml'
  printf '%s\n' '  repeatability: second run left installed state unchanged'
} >"${report_file}"

sed -n '1,20p' "${report_file}"
