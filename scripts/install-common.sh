# Shared helpers for the installers. Source this file; it does not run on its own.

# Moves a file into the backup directory under a timestamped name, so it is never lost.
backup_file() {
  backup_source=$1
  backup_dir=$2
  mkdir -p "${backup_dir}"
  backup_target="${backup_dir}/${backup_source##*/}.$(date +%Y%m%d%H%M%S)"
  [ ! -e "${backup_target}" ] || backup_target="${backup_target}.$$"
  mv "${backup_source}" "${backup_target}"
  printf 'Backed up %s to %s\n' "${backup_source}" "${backup_target}"
}

# Installs a file. A different existing file is backed up first, so a personal file with the same name keeps its
# content; an identical one is left untouched, so repeat installs change nothing.
install_with_backup() {
  install_source=$1
  install_target=$2
  if cmp -s "${install_source}" "${install_target}"; then
    return 0
  fi
  if [ -e "${install_target}" ] || [ -L "${install_target}" ]; then
    backup_file "${install_target}" "$3"
  fi
  install -m 0644 "${install_source}" "${install_target}"
}
