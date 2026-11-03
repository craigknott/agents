#!/bin/sh
# Check that every pinned model is one the installed CLIs can actually select.

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)
codex_models_cache="${CODEX_HOME:-"${HOME}/.codex"}/models_cache.json"

pinned_codex_models() {
  sed -n 's/^model = "\(.*\)"$/\1/p' "${repo_root}"/codex/agents/*.toml | LC_ALL=C sort -u
}

pinned_claude_models() {
  sed -n 's/^model: //p' "${repo_root}"/claude/agents/*.md | LC_ALL=C sort -u
}

failed=0

if [ -f "${codex_models_cache}" ]; then
  for model in $(pinned_codex_models); do
    if ! grep -Fq "\"slug\": \"${model}\"" "${codex_models_cache}" &&
      ! grep -Fq "\"slug\":\"${model}\"" "${codex_models_cache}"; then
      printf 'Codex model not offered by this CLI: %s\n' "${model}" >&2
      failed=1
    fi
  done
else
  printf 'Skipping Codex model check: %s not found\n' "${codex_models_cache}" >&2
fi

for model in $(pinned_claude_models); do
  case ${model} in
    fable | opus | sonnet | haiku | inherit | claude-*) ;;
    *)
      printf 'Claude model is not an alias or full model ID: %s\n' "${model}" >&2
      failed=1
      ;;
  esac
done

[ "${failed}" -eq 0 ]
printf '%s\n' 'Model checks passed for pinned Codex and Claude models.'
