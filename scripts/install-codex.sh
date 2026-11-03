#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
agents_repo_dir=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)
codex_target_dir=${CODEX_HOME:-"${HOME}/.codex"}
codex_agents_dir="${codex_target_dir}/agents"
codex_backup_dir="${codex_target_dir}/backups/agents-pack"

. "${script_dir}/install-common.sh"

if [ -s "${codex_target_dir}/AGENTS.override.md" ]; then
  codex_instructions_file="${codex_target_dir}/AGENTS.override.md"
else
  codex_instructions_file="${codex_target_dir}/AGENTS.md"
fi

mkdir -p "${codex_agents_dir}"

agent_count=0
for agent_file in "${agents_repo_dir}"/codex/agents/*.toml; do
  agent_filename=${agent_file##*/}
  install_with_backup "${agent_file}" "${codex_agents_dir}/${agent_filename}" "${codex_backup_dir}"
  agent_count=$((agent_count + 1))
done

for retired_agent in bulk_scout explorer_sol worker_sol reviewer_sol; do
  if [ -e "${codex_agents_dir}/${retired_agent}.toml" ]; then
    backup_file "${codex_agents_dir}/${retired_agent}.toml" "${codex_backup_dir}"
  fi
done

touch "${codex_instructions_file}"

ensure_include() {
  include_line=$1

  if ! grep -Fqx "${include_line}" "${codex_instructions_file}"; then
    if [ -s "${codex_instructions_file}" ]; then
      printf '\n' >>"${codex_instructions_file}"
    fi
    printf '%s\n' "${include_line}" >>"${codex_instructions_file}"
  fi
}

codex_loader='Read and follow `~/.agents/codex/AGENTS.md`.'
legacy_codex_loader='Read and follow `~/.agents/codex/AGENTS.md` for Codex-specific subagent routing and context rules.'

if grep -Fqx "${legacy_codex_loader}" "${codex_instructions_file}"; then
  loader_tmp=$(mktemp "${TMPDIR:-/tmp}/codex-loader.XXXXXX")
  trap 'rm -f "${loader_tmp}"' EXIT HUP INT TERM
  awk -v old_line="${legacy_codex_loader}" '$0 != old_line { print }' \
    "${codex_instructions_file}" >"${loader_tmp}"
  cat "${loader_tmp}" >"${codex_instructions_file}"
fi

ensure_include "${codex_loader}"

printf 'Installed %s Codex agents in %s\n' "${agent_count}" "${codex_agents_dir}"
printf 'Updated Codex instruction directives in %s\n' "${codex_instructions_file}"
