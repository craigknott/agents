#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

sh "${script_dir}/install-codex.sh"
sh "${script_dir}/install-claude.sh"
