#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
agents_repo_dir=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)
codex_target_dir=${CODEX_HOME:-"${HOME}/.codex"}
codex_agents_dir="${codex_target_dir}/agents"

if [ -s "${codex_target_dir}/AGENTS.override.md" ]; then
  codex_instructions_file="${codex_target_dir}/AGENTS.override.md"
else
  codex_instructions_file="${codex_target_dir}/AGENTS.md"
fi

mkdir -p "${codex_agents_dir}"

for agent_name in explorer worker docs_researcher bulk_scout reviewer; do
  install -m 0644 \
    "${agents_repo_dir}/codex/agents/${agent_name}.toml" \
    "${codex_agents_dir}/${agent_name}.toml"
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

ensure_include 'Read and follow `~/.agents/codex/AGENTS.md` for Codex-specific subagent routing and context rules.'

printf 'Installed five Codex agents in %s\n' "${codex_agents_dir}"
printf 'Updated Codex instruction directives in %s\n' "${codex_instructions_file}"
