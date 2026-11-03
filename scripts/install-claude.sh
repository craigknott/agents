#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
agents_repo_dir=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)
claude_target_dir=${CLAUDE_CONFIG_DIR:-"${HOME}/.claude"}
claude_agents_dir="${claude_target_dir}/agents"
claude_instructions_file="${claude_target_dir}/CLAUDE.md"
claude_backup_dir="${claude_target_dir}/backups/agents-pack"

. "${script_dir}/install-common.sh"

mkdir -p "${claude_agents_dir}"

agent_count=0
for agent_file in "${agents_repo_dir}"/claude/agents/*.md; do
  install_with_backup "${agent_file}" "${claude_agents_dir}/${agent_file##*/}" "${claude_backup_dir}"
  agent_count=$((agent_count + 1))
done

# Codex reads ~/.agents/skills natively; Claude Code reads per-skill symlinks in its skills directory.
shared_skills_dir=${AGENTS_SKILLS_DIR:-"${agents_repo_dir}/skills"}
claude_skills_dir="${claude_target_dir}/skills"
mkdir -p "${claude_skills_dir}"

# Remove only dangling links this installer could have made: exactly <shared skills dir>/<entry name>.
for skill_link in "${claude_skills_dir}"/*; do
  if [ -L "${skill_link}" ] && [ ! -e "${skill_link}" ] &&
    [ "$(readlink "${skill_link}")" = "${shared_skills_dir}/${skill_link##*/}" ]; then
    rm -f "${skill_link}"
  fi
done

linked_count=0
for skill_dir in "${shared_skills_dir}"/*/; do
  [ -f "${skill_dir}SKILL.md" ] || continue
  skill_source=${skill_dir%/}
  skill_name=${skill_source##*/}
  skill_link="${claude_skills_dir}/${skill_name}"
  if [ -L "${skill_link}" ] && [ "$(readlink "${skill_link}")" = "${skill_source}" ]; then
    linked_count=$((linked_count + 1))
  elif [ -e "${skill_link}" ] || [ -L "${skill_link}" ]; then
    printf 'Kept existing Claude skill %s; it is not a link to %s\n' "${skill_name}" "${skill_source}"
  else
    ln -s "${skill_source}" "${skill_link}"
    linked_count=$((linked_count + 1))
  fi
done

touch "${claude_instructions_file}"

claude_loader='@~/.agents/AGENTS.md'
if ! grep -Fqx "${claude_loader}" "${claude_instructions_file}"; then
  if [ -s "${claude_instructions_file}" ]; then
    printf '\n' >>"${claude_instructions_file}"
  fi
  printf '%s\n' "${claude_loader}" >>"${claude_instructions_file}"
fi

printf 'Installed %s Claude agents in %s\n' "${agent_count}" "${claude_agents_dir}"
printf 'Linked %s shared skills in %s\n' "${linked_count}" "${claude_skills_dir}"
printf 'Updated Claude instruction import in %s\n' "${claude_instructions_file}"
