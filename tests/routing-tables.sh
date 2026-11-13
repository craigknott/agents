#!/bin/sh
# Check that the routing tables in the documentation show the model and effort that each role file pins.

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)

# A Claude cell is the capitalized model alias, then the effort when one is pinned: "Sonnet medium", "Haiku".
claude_cell() {
  awk '/^---$/ { fences++; next } fences != 1 { next }
    sub(/^model: /, "") { model = toupper(substr($0, 1, 1)) substr($0, 2) }
    sub(/^effort: /, "") { effort = " " $0 }
    END { print model effort }' "$1"
}

# A Codex cell is the model in backticks, then the effort: "`gpt-6.1-sol` medium".
codex_cell() {
  printf '`%s` %s\n' "$(sed -n 's/^model = "\(.*\)"$/\1/p' "$1")" \
    "$(sed -n 's/^model_reasoning_effort = "\(.*\)"$/\1/p' "$1")"
}

# Prints the cell under the named column for every row of the role, in the table whose first column is "Role".
# Each cell is in brackets, so a row with an empty cell still counts as a row.
shown_cells() {
  awk -F ' *[|] *' -v role="\`$2\`" -v column="$3" '
    $2 == "Role" { wanted = 0; for (i = 3; i <= NF; i++) if ($i == column) wanted = i; next }
    wanted && $2 == role { print "[" $wanted "]" }' "${repo_root}/$1"
}

failed=0

# One row must show the expected cell. A second row for the same role fails, even when it agrees or is empty.
check_cell() {
  shown=$(shown_cells "$1" "$2" "$3")
  if [ "${shown}" != "[$4]" ]; then
    printf '%s: the %s column for %s shows %s, not exactly one [%s]\n' "$1" "$3" "$2" \
      "$(printf '%s' "${shown}" | tr '\n' ' ')" "$4" >&2
    failed=1
  fi
}

for codex_role in "${repo_root}"/codex/agents/*.toml; do
  role=$(basename "${codex_role}" .toml)
  claude_role="${repo_root}/claude/agents/${role}.md"
  for doc in instructions/delegation.md README.md; do
    if [ -z "$(shown_cells "${doc}" "${role}" Codex)" ]; then
      # A role on both platforms needs a row in every table; a one-platform role may be described in prose.
      if [ -f "${claude_role}" ]; then
        printf '%s: no routing row for %s\n' "${doc}" "${role}" >&2
        failed=1
      fi
      continue
    fi
    check_cell "${doc}" "${role}" Codex "$(codex_cell "${codex_role}")"
    [ ! -f "${claude_role}" ] || check_cell "${doc}" "${role}" Claude "$(claude_cell "${claude_role}")"
  done
done

[ "${failed}" -eq 0 ]
printf '%s\n' 'Routing tables match the models and efforts pinned in the role files.'
