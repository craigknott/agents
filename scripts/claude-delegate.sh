#!/bin/sh
# Run one delegated task on Claude Code's headless CLI and print its final message.
# For Codex agents and other callers without a native route to Claude. Use the harness's own
# cross-provider tool instead when one exists. Claude Code reaches Codex through the codex plugin.
# The role files in claude/agents are the source of truth for each role.

set -eu

usage() {
  cat >&2 <<'EOF'
usage: claude-delegate.sh <scout|explorer|worker|reviewer|deep_reviewer> [-C dir] [-t seconds] < brief

Reads the task brief from stdin and prints Claude's final message to stdout.
Exit codes: 2 bad usage, 3 nested delegation refused, 4 empty result, 124 timeout,
129/130/143 cancelled by HUP/INT/TERM; otherwise Claude's own status.
On any failure, Claude's output goes to stderr, never stdout. Requires perl.
EOF
  exit 2
}

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
agents_repo_dir=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)

[ $# -ge 1 ] || usage
role=$1
shift

work_dir=.
timeout_seconds=1800
while [ $# -gt 0 ]; do
  case $1 in
    -C)
      [ $# -ge 2 ] || usage
      work_dir=$2
      shift 2
      ;;
    -t)
      [ $# -ge 2 ] || usage
      timeout_seconds=$2
      shift 2
      ;;
    *) usage ;;
  esac
done

case ${role} in
  scout | explorer | worker | reviewer | deep_reviewer) ;;
  *) usage ;;
esac
case ${timeout_seconds} in
  '' | *[!0-9]* | 0) usage ;;
esac
role_file="${agents_repo_dir}/claude/agents/${role}.md"

command -v perl >/dev/null 2>&1 || {
  echo "claude-delegate: requires perl to supervise the Claude run" >&2
  exit 2
}

depth=${AGENT_DEPTH:-0}
if [ "${depth}" -ge 1 ]; then
  echo "claude-delegate: refusing nested delegation (AGENT_DEPTH=${depth}); do the work yourself" >&2
  exit 3
fi

[ -f "${role_file}" ] || {
  echo "claude-delegate: missing role file: ${role_file}" >&2
  exit 2
}
[ -d "${work_dir}" ] || {
  echo "claude-delegate: no such directory: ${work_dir}" >&2
  exit 2
}

temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/claude-delegate.XXXXXX")
trap 'rm -rf "${temp_dir}"' EXIT

{
  printf 'You are a delegated %s child agent. Do the work yourself; do not delegate or start subagents.\n\n' "${role}"
  cat
} >"${temp_dir}/brief"

frontmatter() {
  awk -v key="$1" '/^---$/ { fences++; next } fences == 1 && index($0, key ": ") == 1 {
    print substr($0, length(key) + 3) }' "${role_file}"
}
awk 'fences >= 2 { print } /^---$/ { fences++ }' "${role_file}" >"${temp_dir}/role"

set -- --model "$(frontmatter model)" --append-system-prompt-file "${temp_dir}/role"
effort=$(frontmatter effort)
[ -z "${effort}" ] || set -- "$@" --effort "${effort}"
if [ "${role}" = worker ]; then
  set -- "$@" --permission-mode auto
else
  # Restricted mode ignores settings files, so inherited allow rules cannot widen a read-only role.
  set -- "$@" --restricted --tools 'Read,Grep,Glob,Bash' \
    --disallowedTools 'Write,Edit,NotebookEdit' --permission-mode dontAsk \
    --allowedTools 'Read,Grep,Glob,Bash(git diff:*),Bash(git log:*),Bash(git show:*),Bash(git status:*)'
fi

AGENT_DEPTH=$((depth + 1))
export AGENT_DEPTH

CDPATH= cd -- "${work_dir}"
# The supervisor owns the Claude run from here: timeout, cancellation, output, exit status, and temp-dir cleanup.
# exec makes it this process, so signals sent to the wrapper reach it directly.
trap - EXIT
exec perl "${script_dir}/claude-delegate-supervisor.pl" "${timeout_seconds}" 5 "${temp_dir}" \
  claude -p --output-format text --no-session-persistence "$@"
