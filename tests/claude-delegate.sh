#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd -P)
delegate="${repo_root}/scripts/claude-delegate.sh"

test_root=$(mktemp -d "${TMPDIR:-/tmp}/claude-delegate-test.XXXXXX")
# On exit, kill any stub process a regression left running. Each PID is checked against its expected command
# first, so a stale PID that the system has reused for an unrelated process is never signalled.
kill_if_ours() {
  case $(ps -o command= -p "$1" 2>/dev/null) in
    *"$2"*) kill -KILL "$1" 2>/dev/null || true ;;
  esac
}
cleanup() {
  [ ! -s "${test_root}/child.pid" ] || kill_if_ours "$(cat "${test_root}/child.pid")" "${stub_bin}/claude"
  [ ! -s "${test_root}/grandchild.pid" ] || kill_if_ours "$(cat "${test_root}/grandchild.pid")" 'sleep 60'
  [ ! -s "${test_root}/spawned.pid" ] || kill_if_ours "$(cat "${test_root}/spawned.pid")" 'sleep 45'
  [ ! -s "${test_root}/left.pid" ] || kill_if_ours "$(cat "${test_root}/left.pid")" 'sleep 50'
  rm -rf "${test_root}"
}
trap cleanup EXIT HUP INT TERM

stub_bin="${test_root}/bin"
mkdir -p "${stub_bin}" "${test_root}/repo"

# The stub records argv (one per line), stdin, cwd, AGENT_DEPTH, and the role prompt.
# STUB_MODE selects its behavior: answer (default), empty, fail, or hang.
cat >"${stub_bin}/claude" <<EOF
#!/bin/sh
printf '%s\n' "\$@" >"${test_root}/claude.args"
cat >"${test_root}/claude.stdin"
pwd -P >"${test_root}/claude.cwd"
printf '%s\n' "\${AGENT_DEPTH:-unset}" >"${test_root}/claude.depth"
while [ \$# -gt 0 ]; do
  if [ "\$1" = --append-system-prompt-file ]; then cp "\$2" "${test_root}/claude.role"; fi
  shift
done
case \${STUB_MODE:-answer} in
  empty) printf '  \n' ;;
  fail) printf 'partial verdict: no findings\n'; exit 7 ;;
  hang) printf 'still thinking\n'; exec sleep 30 ;;
  leaver)
    (exec sleep 50) &
    printf '%s\n' "\$!" >"${test_root}/left.pid"
    printf 'claude final answer\n'
    ;;
  spawner)
    trap '(exec sleep 45) & printf "%s\\n" "\$!" >"${test_root}/spawned.pid"; exit 0' TERM
    printf '%s\n' "\$\$" >"${test_root}/child.pid"
    while :; do sleep 1; done
    ;;
  stubborn)
    trap '' TERM
    (trap '' TERM; exec sleep 60) &
    printf '%s\n' "\$!" >"${test_root}/grandchild.pid"
    printf '%s\n' "\$\$" >"${test_root}/child.pid"
    while :; do sleep 1; done
    ;;
  *) printf 'claude final answer\n' ;;
esac
EOF
chmod +x "${stub_bin}/claude"

run() {
  PATH="${stub_bin}:${PATH}" "${delegate}" "$@"
}

has_arg_pair() {
  grep -Fxq -- "$1" "${test_root}/claude.args" &&
    test "$(grep -Fx -A1 -- "$1" "${test_root}/claude.args" | sed -n 2p)" = "$2"
}

expect_status() {
  expected=$1
  shift
  status=0
  "$@" || status=$?
  test "${status}" -eq "${expected}"
}

# Deep reviewer: Fable, restricted read-only tools, role prompt from the role file, requested directory.
out=$(printf 'Review deeply.\n' | run deep_reviewer -C "${test_root}/repo")
test "${out}" = 'claude final answer'
has_arg_pair --model fable
has_arg_pair --effort high
has_arg_pair --permission-mode dontAsk
grep -Fxq -- --restricted "${test_root}/claude.args"
has_arg_pair --disallowedTools 'Write,Edit,NotebookEdit'
grep -Fq 'Read,Grep,Glob' "${test_root}/claude.args"
grep -Fq 'Review the assigned change like an owner' "${test_root}/claude.role"
if grep -Fq 'name: deep_reviewer' "${test_root}/claude.role"; then exit 1; fi
test "$(cat "${test_root}/claude.cwd")" = "$(CDPATH= cd -- "${test_root}/repo" && pwd -P)"
grep -Fq 'Review deeply.' "${test_root}/claude.stdin"
grep -Fq 'do not delegate' "${test_root}/claude.stdin"
test "$(cat "${test_root}/claude.depth")" = 1

# Scout omits effort; worker may edit and is not restricted.
printf 'Scan.\n' | run scout >/dev/null
has_arg_pair --model haiku
if grep -Fxq -- --effort "${test_root}/claude.args"; then exit 1; fi
printf 'Build.\n' | run worker >/dev/null
has_arg_pair --permission-mode auto
if grep -Fxq -- --restricted "${test_root}/claude.args"; then exit 1; fi

# A relative -C resolves against the current directory, never against an inherited CDPATH.
mkdir -p "${test_root}/decoy/repo"
(cd "${test_root}" && printf 'Scan.\n' | CDPATH="${test_root}/decoy" run scout -C repo >"${test_root}/cdpath.out")
test "$(cat "${test_root}/claude.cwd")" = "$(CDPATH= cd -- "${test_root}/repo" && pwd -P)"
test "$(cat "${test_root}/cdpath.out")" = 'claude final answer'

# A successful run still leaves no background process behind.
export STUB_MODE=leaver
out=$(printf 'Scan.\n' | run scout)
test "${out}" = 'claude final answer'
sleep 0.3
if kill -0 "$(cat "${test_root}/left.pid")" 2>/dev/null; then
  printf 'A background process outlived a successful run\n' >&2
  exit 1
fi
unset STUB_MODE

# Failures never put output on stdout, so a caller cannot mistake them for a verdict.
printf 'Review.\n' >"${test_root}/brief"
export STUB_MODE=empty
expect_status 4 run reviewer <"${test_root}/brief" >"${test_root}/empty.out" 2>"${test_root}/empty.err"
test ! -s "${test_root}/empty.out"
grep -Fq 'empty result' "${test_root}/empty.err"

export STUB_MODE=fail
expect_status 7 run reviewer <"${test_root}/brief" >"${test_root}/fail.out" 2>"${test_root}/fail.err"
test ! -s "${test_root}/fail.out"
grep -Fq 'partial verdict' "${test_root}/fail.err"

started=$(date +%s)
export STUB_MODE=hang
expect_status 124 run reviewer -t 1 <"${test_root}/brief" >"${test_root}/hang.out" 2>"${test_root}/hang.err"
test $(($(date +%s) - started)) -lt 10
test ! -s "${test_root}/hang.out"
grep -Fq 'timed out after 1s' "${test_root}/hang.err"
unset STUB_MODE

# A child that ignores TERM, and a grandchild it started, are still stopped by timeout and by cancellation.
tree_is_gone() {
  for pid_file in "${test_root}/child.pid" "${test_root}/grandchild.pid"; do
    if kill -0 "$(cat "${pid_file}")" 2>/dev/null; then return 1; fi
  done
}
wait_for_file() {
  waited=0
  while [ ! -s "$1" ] && [ "${waited}" -lt 50 ]; do sleep 0.1; waited=$((waited + 1)); done
  test -s "$1"
}

# Waits for a background process, killing it and failing if it outlives the deadline, so a hang fails the test.
await_exit() {
  waited=0
  while kill -0 "$1" 2>/dev/null; do
    if [ "${waited}" -ge $(($2 * 10)) ]; then
      kill -KILL "$1" 2>/dev/null || true
      printf 'Still running after %ss: process %s\n' "$2" "$1" >&2
      return 99
    fi
    sleep 0.1
    waited=$((waited + 1))
  done
  wait "$1"
}

export STUB_MODE=stubborn
PATH="${stub_bin}:${PATH}" "${delegate}" reviewer -t 1 <"${test_root}/brief" \
  >"${test_root}/stubborn.out" 2>"${test_root}/stubborn.err" &
expect_status 124 await_exit "$!" 15
test ! -s "${test_root}/stubborn.out"
tree_is_gone

rm -f "${test_root}/child.pid" "${test_root}/grandchild.pid"
PATH="${stub_bin}:${PATH}" "${delegate}" worker -t 60 <"${test_root}/brief" >"${test_root}/cancel.out" 2>"${test_root}/cancel.err" &
wrapper=$!
wait_for_file "${test_root}/grandchild.pid"
kill -TERM "${wrapper}"
expect_status 143 await_exit "${wrapper}" 15
test ! -s "${test_root}/cancel.out"
tree_is_gone

# A process the child starts while shutting down is still stopped.
export STUB_MODE=spawner
rm -f "${test_root}/child.pid" "${test_root}/spawned.pid"
PATH="${stub_bin}:${PATH}" "${delegate}" reviewer -t 1 <"${test_root}/brief" >/dev/null 2>&1 &
expect_status 124 await_exit "$!" 15
wait_for_file "${test_root}/spawned.pid"
if kill -0 "$(cat "${test_root}/spawned.pid")" 2>/dev/null; then
  printf 'A process started during shutdown survived\n' >&2
  exit 1
fi
unset STUB_MODE

# Nested delegation is refused before Claude runs.
rm -f "${test_root}/claude.args"
export AGENT_DEPTH=1
expect_status 3 run reviewer <"${test_root}/brief" >/dev/null 2>"${test_root}/nested.err"
unset AGENT_DEPTH
test ! -e "${test_root}/claude.args"
grep -Fq 'refusing nested delegation' "${test_root}/nested.err"

# Unknown roles, providers, and bad timeouts are usage errors.
for bad in architect codex 'reviewer -t 0' 'reviewer -t soon'; do
  # shellcheck disable=SC2086
  expect_status 2 run ${bad} </dev/null >/dev/null 2>&1
done

printf '%s\n' 'Claude delegation checks passed for routing, restriction, failures, timeout, and the nesting guard.'
