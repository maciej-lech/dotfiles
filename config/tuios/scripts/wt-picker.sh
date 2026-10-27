#!/usr/bin/env bash
# Popup for ctrl+a U: worktrunk picker, opening the chosen worktree as a tuios session
root=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")

if ! command -v wt >/dev/null; then
  read -rsn1 -p "worktrunk (wt) not found in PATH, press any key to close"
  exit 1
fi
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  read -rsn1 -p "$PWD is not in a git repository, press any key to close"
  exit 1
fi

wt switch --branches --no-cd -x "$root/wt-open.sh" -- \
  '{{ branch }}' '{{ worktree_path }}' '{{ primary_worktree_path }}'

"$root/wt-cleanup.sh"
