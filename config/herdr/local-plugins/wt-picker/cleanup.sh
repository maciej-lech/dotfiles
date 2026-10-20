#!/usr/bin/env bash
# Close worktree spaces whose checkout no longer exists (e.g. removed with `wt remove`)
# Checks for .git, as `wt remove` run from inside a worktree leaves an empty placeholder directory behind.
h=${HERDR_BIN_PATH:-herdr}
"$h" workspace list \
  | jq -r '.result.workspaces[] | select(.worktree.is_linked_worktree == true) | [.workspace_id, .worktree.checkout_path] | @tsv' \
  | while IFS=$'\t' read -r id path; do
      [[ -e $path/.git ]] || "$h" workspace close "$id" >/dev/null
    done
