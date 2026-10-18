#!/usr/bin/env bash
root=$(dirname -- "${BASH_SOURCE[0]}")

if ! command -v wt >/dev/null; then
  read -rsn1 -p "worktrunk (wt) not found in PATH, press any key to close"
  exit 1
fi

wt switch --branches --no-cd -x "$root/open-worktree.sh" -- \
  '{{ branch }}' '{{ worktree_path }}' '{{ primary_worktree_path }}'

"$root/cleanup.sh"
