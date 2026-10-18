#!/usr/bin/env bash
# Close worktree spaces whose checkout no longer exists (e.g. removed with `wt remove`)
h=${HERDR_BIN_PATH:-herdr}
"$h" workspace list \
  | jq -r '.result.workspaces[] | select(.worktree.is_linked_worktree == true) | [.workspace_id, .worktree.checkout_path] | @tsv' \
  | while IFS=$'\t' read -r id path; do
      [[ -d $path ]] || "$h" workspace close "$id" >/dev/null
    done
