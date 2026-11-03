#!/bin/sh
# Check that each shared role has the same name and instructions on Claude and Codex.

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)

# Roles that exist on one platform only, with the reason.
codex_only='docs_researcher' # Needs the OpenAI Docs MCP server, configured only in Codex.

codex_instructions() {
  awk '/^developer_instructions = """$/ { body = 1; next } body && /^"""$/ { exit } body && NF' "$1"
}

claude_instructions() {
  awk 'fences >= 2 && NF { print } /^---$/ { fences++ }' "$1"
}

failed=0

for claude_role in "${repo_root}"/claude/agents/*.md; do
  role=$(basename "${claude_role}" .md)
  codex_role="${repo_root}/codex/agents/${role}.toml"
  if [ "$(sed -n 's/^name: //p' "${claude_role}")" != "${role}" ]; then
    printf 'Claude role name does not match its file: %s\n' "${role}" >&2
    failed=1
  fi
  if [ ! -f "${codex_role}" ]; then
    printf 'Claude role has no Codex counterpart: %s\n' "${role}" >&2
    failed=1
    continue
  fi
  if [ "$(sed -n 's/^name = "\(.*\)"$/\1/p' "${codex_role}")" != "${role}" ]; then
    printf 'Codex role name does not match its file: %s\n' "${role}" >&2
    failed=1
  fi
  if [ "$(claude_instructions "${claude_role}")" != "$(codex_instructions "${codex_role}")" ]; then
    printf 'Role instructions differ between Claude and Codex: %s\n' "${role}" >&2
    failed=1
  fi
done

for codex_role in "${repo_root}"/codex/agents/*.toml; do
  role=$(basename "${codex_role}" .toml)
  if [ ! -f "${repo_root}/claude/agents/${role}.md" ] && [ "${role}" != "${codex_only}" ]; then
    printf 'Codex role has no Claude counterpart: %s\n' "${role}" >&2
    failed=1
  fi
done

[ "${failed}" -eq 0 ]
printf '%s\n' 'Role parity checks passed for Claude and Codex.'
