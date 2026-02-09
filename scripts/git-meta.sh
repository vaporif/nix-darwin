#!/usr/bin/env bash
# Sync non-tracked config files between .meta/ and git worktrees
# Usage: git meta <push|pull|diff|init>
set -euo pipefail

DEFAULTS=(.envrc .serena/ .claude/ CLAUDE.md)

die() { echo "error: $*" >&2; exit 1; }
warn() { echo "warning: $*" >&2; }

get_bare_dir() {
  local common_dir
  common_dir=$(git rev-parse --git-common-dir 2>/dev/null) || die "not in a git repo"
  common_dir=$(cd "${common_dir}" && pwd -P)
  echo "${common_dir}"
}

get_meta_dir() {
  local bare_dir
  bare_dir=$(get_bare_dir)
  echo "$(dirname "${bare_dir}")/.meta"
}

get_worktree_root() {
  git rev-parse --show-toplevel 2>/dev/null || die "not in a worktree"
}

assert_worktree() {
  local git_dir common_dir
  git_dir=$(git rev-parse --git-dir 2>/dev/null) || die "not in a git repo"
  git_dir=$(cd "${git_dir}" && pwd -P)
  common_dir=$(get_bare_dir)
  [[ "${git_dir}" != "${common_dir}" ]] || die "not in a worktree (run from inside a worktree)"
}

get_files() {
  local meta_dir="$1"
  if [[ -f "${meta_dir}/.files" ]]; then
    grep -v '^\s*#' "${meta_dir}/.files" | grep -v '^\s*$' || true
  else
    printf '%s\n' "${DEFAULTS[@]}"
  fi
}

sync_entry() {
  local src_base="$1" dst_base="$2" entry="${3%/}"
  local src="${src_base}/${entry}" dst="${dst_base}/${entry}"

  if [[ ! -e "${src}" ]]; then
    warn "skipping ${entry} (not found in source)"
    return
  fi

  if [[ -d "${src}" ]]; then
    if [[ -d "${dst}" ]]; then
      rm -rf "${dst}.bak"
      mv "${dst}" "${dst}.bak"
    fi
    mkdir -p "${dst}"
    rsync -a --exclude 'cache/' --exclude '.bak' "${src}/" "${dst}/"
  else
    if [[ -f "${dst}" ]]; then
      cp -f "${dst}" "${dst}.bak"
    fi
    mkdir -p "$(dirname "${dst}")"
    cp -f "${src}" "${dst}"
  fi
}

diff_entry() {
  local src_base="$1" dst_base="$2" entry="${3%/}"
  local src="${src_base}/${entry}" dst="${dst_base}/${entry}"

  if [[ ! -e "${src}" && ! -e "${dst}" ]]; then
    return
  fi
  if [[ ! -e "${src}" ]]; then
    echo "only in $(basename "${dst_base}"): ${entry}"
    return
  fi
  if [[ ! -e "${dst}" ]]; then
    echo "only in $(basename "${src_base}"): ${entry}"
    return
  fi

  if [[ -d "${src}" ]]; then
    diff -rq --exclude='cache' --exclude='.bak' "${src}" "${dst}" 2>/dev/null || true
  else
    diff -u "${src}" "${dst}" 2>/dev/null || true
  fi
}

cmd_push() {
  assert_worktree
  local meta_dir wt_root
  meta_dir=$(get_meta_dir)
  wt_root=$(get_worktree_root)
  [[ -d "${meta_dir}" ]] || die ".meta/ not found at ${meta_dir} (run 'git meta init' first)"

  local files
  files=$(get_files "${meta_dir}")
  while IFS= read -r entry; do
    [[ -n "${entry}" ]] || continue
    echo "push: ${entry}"
    sync_entry "${wt_root}" "${meta_dir}" "${entry}"
  done <<< "${files}"
}

cmd_pull() {
  assert_worktree
  local meta_dir wt_root
  meta_dir=$(get_meta_dir)
  wt_root=$(get_worktree_root)
  [[ -d "${meta_dir}" ]] || die ".meta/ not found at ${meta_dir} (run 'git meta init' first)"

  local files
  files=$(get_files "${meta_dir}")
  while IFS= read -r entry; do
    [[ -n "${entry}" ]] || continue
    echo "pull: ${entry}"
    sync_entry "${meta_dir}" "${wt_root}" "${entry}"
  done <<< "${files}"
}

cmd_diff() {
  assert_worktree
  local meta_dir wt_root
  meta_dir=$(get_meta_dir)
  wt_root=$(get_worktree_root)
  [[ -d "${meta_dir}" ]] || die ".meta/ not found at ${meta_dir} (run 'git meta init' first)"

  local files
  files=$(get_files "${meta_dir}")
  while IFS= read -r entry; do
    [[ -n "${entry}" ]] || continue
    diff_entry "${meta_dir}" "${wt_root}" "${entry}"
  done <<< "${files}"
}

cmd_init() {
  assert_worktree
  local meta_dir wt_root
  meta_dir=$(get_meta_dir)
  wt_root=$(get_worktree_root)

  if [[ -d "${meta_dir}" ]]; then
    warn ".meta/ already exists at ${meta_dir}"
  else
    mkdir -p "${meta_dir}"
    echo "created ${meta_dir}"
  fi

  if [[ ! -f "${meta_dir}/.files" ]]; then
    printf '# files to sync between .meta/ and worktrees\n' > "${meta_dir}/.files"
    printf '%s\n' "${DEFAULTS[@]}" >> "${meta_dir}/.files"
    echo "created ${meta_dir}/.files"
  fi

  local files
  files=$(get_files "${meta_dir}")
  while IFS= read -r entry; do
    [[ -n "${entry}" ]] || continue
    if [[ -e "${wt_root}/${entry}" ]]; then
      echo "init: ${entry}"
      sync_entry "${wt_root}" "${meta_dir}" "${entry}"
    fi
  done <<< "${files}"
}

case "${1:-}" in
  push) cmd_push ;;
  pull) cmd_pull ;;
  diff) cmd_diff ;;
  init) cmd_init ;;
  *)    echo "Usage: git meta <push|pull|diff|init>" >&2; exit 1 ;;
esac
