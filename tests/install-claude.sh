#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)

test_root=$(mktemp -d "${TMPDIR:-/tmp}/install-claude-test.XXXXXX")
trap 'rm -rf "${test_root}"' EXIT HUP INT TERM

claude_loader='@~/.agents/AGENTS.md'

if grep -En '/Users/|/home/|[A-Za-z]:\\Users\\' "${repo_root}"/claude/agents/*.md "${repo_root}"/scripts/install-*.sh; then
  printf '%s\n' 'Machine-local path found in portable Claude files' >&2
  exit 1
fi

shared_skills="${test_root}/shared-skills"
mkdir -p "${shared_skills}/new-skill" "${shared_skills}/kept-skill" "${shared_skills}/not-a-skill"
printf '%s\n' '---' 'name: new-skill' '---' >"${shared_skills}/new-skill/SKILL.md"
printf '%s\n' '---' 'name: kept-skill' '---' >"${shared_skills}/kept-skill/SKILL.md"
AGENTS_SKILLS_DIR="${shared_skills}"
export AGENTS_SKILLS_DIR

existing_home="${test_root}/existing"
mkdir -p "${existing_home}/agents" "${existing_home}/skills/kept-skill"
printf '%s\n' 'personal copy' >"${existing_home}/skills/kept-skill/SKILL.md"
ln -s "${shared_skills}/removed-skill" "${existing_home}/skills/removed-skill"
ln -s "${test_root}/elsewhere/broken" "${existing_home}/skills/unrelated-broken"
ln -s "${shared_skills}/../personal/missing" "${existing_home}/skills/escaping-broken"
printf '%s\n' '# Keep this personal instruction.' >"${existing_home}/CLAUDE.md"
printf '%s\n' '---' 'name: unrelated' '---' >"${existing_home}/agents/unrelated.md"
printf '%s\n' '---' 'name: reviewer' '---' 'My personal reviewer.' >"${existing_home}/agents/reviewer.md"
printf '%s\n' '{"sentinel": true}' >"${existing_home}/settings.json"
settings_before=$(cksum "${existing_home}/settings.json")
unrelated_before=$(cksum "${existing_home}/agents/unrelated.md")

CLAUDE_CONFIG_DIR="${existing_home}" "${repo_root}/scripts/install-claude.sh" >"${test_root}/first.txt"

for agent_file in "${repo_root}"/claude/agents/*.md; do
  cmp "${agent_file}" "${existing_home}/agents/${agent_file##*/}"
done
grep -Fq 'Installed 5 Claude agents in ' "${test_root}/first.txt"
grep -Fq '# Keep this personal instruction.' "${existing_home}/CLAUDE.md"
test "$(grep -Fxc "${claude_loader}" "${existing_home}/CLAUDE.md")" -eq 1
test "$(cksum "${existing_home}/settings.json")" = "${settings_before}"
test "$(cksum "${existing_home}/agents/unrelated.md")" = "${unrelated_before}"
personal_backup=$(find "${existing_home}/backups/agents-pack" -name 'reviewer.md.*' -type f)
test "$(printf '%s\n' "${personal_backup}" | wc -l)" -eq 1
grep -Fxq 'My personal reviewer.' "${personal_backup}"
grep -Fq "Backed up ${existing_home}/agents/reviewer.md to " "${test_root}/first.txt"
test "$(readlink "${existing_home}/skills/new-skill")" = "${shared_skills}/new-skill"
test "$(cat "${existing_home}/skills/kept-skill/SKILL.md")" = 'personal copy'
test ! -L "${existing_home}/skills/kept-skill"
grep -Fq 'Kept existing Claude skill kept-skill' "${test_root}/first.txt"
test ! -L "${existing_home}/skills/removed-skill"
test -L "${existing_home}/skills/unrelated-broken"
test -L "${existing_home}/skills/escaping-broken"
test ! -e "${existing_home}/skills/not-a-skill"
grep -Fq 'Linked 1 shared skills in ' "${test_root}/first.txt"

home_state() {
  find "${existing_home}" -type f -exec cksum {} \; | LC_ALL=C sort
  find "${existing_home}" -type l -exec sh -c 'printf "%s -> %s\n" "$1" "$(readlink "$1")"' sh {} \; | LC_ALL=C sort
}
state_before_repeat=$(home_state)
CLAUDE_CONFIG_DIR="${existing_home}" "${repo_root}/scripts/install-claude.sh" >"${test_root}/second.txt"
state_after_repeat=$(home_state)
test "${state_after_repeat}" = "${state_before_repeat}"

default_home="${test_root}/default-user-home"
mkdir -p "${default_home}"
(
  unset CLAUDE_CONFIG_DIR
  HOME="${default_home}" "${repo_root}/scripts/install-claude.sh"
) >"${test_root}/default.txt"
test "$(cat "${default_home}/.claude/CLAUDE.md")" = "${claude_loader}"

printf '%s\n' 'Claude installer checks passed for an existing config, role backups, shared skill links, repeat installs, and the default home.'
