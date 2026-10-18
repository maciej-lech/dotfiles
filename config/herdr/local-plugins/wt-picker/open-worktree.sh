#!/usr/bin/env bash
# Called by `wt switch -x` with: <branch> <worktree path> <primary worktree path>
branch=$1 path=$2 primary=$3

# The main worktree is the repo's own space; labeling it would rename it to the branch
label=()
[[ $path != "$primary" ]] && label=(--label "$branch")

exec "$HERDR_BIN_PATH" worktree open --cwd "$primary" --path "$path" "${label[@]}" --focus >/dev/null
