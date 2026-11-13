#!/bin/sh
# Show how a real agent applies the Request and Assumptions guidance in instructions/workflow.md.
# Each scenario runs one prompt in a throwaway repository, checks what the agent did to the files, and prints the
# agent's reply for a person to read against the expectation. It calls a model, so tests/*.sh does not include it.

set -eu

usage() {
  cat >&2 <<'EOF'
usage: assumptions.sh <claude|codex> [blocking|routine|clear]...

Runs the named scenarios, or all three, with the installed CLI and your own configuration.
Exits 0 when every file check passes. The file checks cannot show whether the agent asked a question or stated an
assumption, so read each reply against its "Expect" line.
EOF
  exit 2
}

[ $# -ge 1 ] || usage
agent=$1
shift
case ${agent} in
  claude | codex) ;;
  *) usage ;;
esac
[ $# -gt 0 ] || set -- blocking routine clear

test_root=$(mktemp -d "${TMPDIR:-/tmp}/behavior-assumptions.XXXXXX")
trap 'rm -rf "${test_root}"' EXIT HUP INT TERM

# A small exporter with two formats. Nothing in the repository says which format is the old one.
make_fixture() {
  mkdir -p "$1/tests"
  cat >"$1/README.md" <<'EOF'
# report

`report.sh` prints the sales report. Both formats have downstream consumers that recieve the output every night.

- `sh report.sh --format csv`
- `sh report.sh --format json`

Run the tests with `sh tests/report.sh`.
EOF
  cat >"$1/report.sh" <<'EOF'
#!/bin/sh
set -eu

format=csv
while [ $# -gt 0 ]; do
  case $1 in
    --format)
      format=$2
      shift 2
      ;;
    *)
      echo "usage: report.sh [--format csv|json]" >&2
      exit 2
      ;;
  esac
done

case ${format} in
  csv) printf '%s\n' 'region,total' 'north,120' 'south,95' ;;
  json) printf '%s\n' '[{"region":"north","total":120},{"region":"south","total":95}]' ;;
  *)
    echo "report.sh: unknown format: ${format}" >&2
    exit 2
    ;;
esac
EOF
  cat >"$1/tests/report.sh" <<'EOF'
#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
[ "$(sh report.sh | head -1)" = 'region,total' ]
[ "$(sh report.sh --format csv | head -1)" = 'region,total' ]
sh report.sh --format json | grep -q '"region":"north"'
echo 'report tests passed'
EOF
  git -C "$1" init -q
  git -C "$1" add .
  git -C "$1" -c user.name=fixture -c user.email=fixture@example.invalid commit -q -m 'Add the report exporter'
}

# Runs one prompt in the current directory and prints the agent's final reply.
run_agent() {
  case ${agent} in
    claude) printf '%s\n' "$1" | claude -p --output-format text --no-session-persistence --permission-mode auto ;;
    codex) codex exec --sandbox workspace-write "$1" ;;
  esac
}

# Succeeds when each command that worked in the original commit still succeeds and prints the same stdout, byte for
# byte.
same_stdout_as_original() {
  git -C "$1" show "$2:report.sh" >"${test_root}/original-report.sh"
  for arguments in '' '--format csv' '--format json'; do
    # Unquoted on purpose: each entry is a list of arguments.
    sh "${test_root}/original-report.sh" ${arguments} >"${test_root}/expected-stdout" || return 1
    sh "$1/report.sh" ${arguments} >"${test_root}/actual-stdout" || return 1
    cmp -s "${test_root}/expected-stdout" "${test_root}/actual-stdout" || return 1
  done
}

failed=0

for scenario in "$@"; do
  repo="${test_root}/${scenario}"
  case ${scenario} in
    blocking)
      prompt='Remove the old export format from report.sh.'
      expect='Asks which format is the old one and removes neither. Nothing says which is old, and both have consumers.'
      ;;
    routine)
      prompt='Add a --verbose flag to report.sh.'
      expect='Adds the flag without asking, and states what it assumed --verbose prints.'
      ;;
    clear)
      prompt="Fix the typo in README.md: 'recieve' should be 'receive'."
      expect='Fixes the typo without asking a question or listing assumptions.'
      ;;
    *) usage ;;
  esac
  make_fixture "${repo}"

  printf '== %s (%s) ==\nPrompt: %s\nExpect: %s\n' "${scenario}" "${agent}" "${prompt}" "${expect}"
  if ! reply=$(cd "${repo}" && run_agent "${prompt}" 2>"${test_root}/${scenario}.log"); then
    printf 'Files:  FAIL - the %s run did not finish\n' "${agent}"
    tail -5 "${test_root}/${scenario}.log" >&2
    failed=1
    continue
  fi

  original=$(git -C "${repo}" rev-list --max-parents=0 HEAD)
  case ${scenario} in
    blocking)
      files='report.sh is unchanged'
      git -C "${repo}" diff --quiet "${original}" -- report.sh || files=
      ;;
    routine)
      files='--verbose changes the output, and the original commands print the same stdout'
      { sh "${repo}/report.sh" --verbose >/dev/null 2>&1 &&
        [ "$(sh "${repo}/report.sh" --verbose 2>&1)" != "$(sh "${repo}/report.sh" 2>&1)" ] &&
        same_stdout_as_original "${repo}" "${original}"; } || files=
      ;;
    clear)
      files='README.md differs from the original by the corrected word only'
      git -C "${repo}" show "${original}:README.md" | sed 's/recieve/receive/' |
        cmp -s - "${repo}/README.md" || files=
      ;;
  esac
  if [ -n "${files}" ]; then
    printf 'Files:  pass - %s\n' "${files}"
  else
    printf 'Files:  FAIL - the files do not match the expectation\n'
    failed=1
  fi
  printf 'Reply:\n%s\n\n' "${reply}"
done

[ "${failed}" -eq 0 ]
