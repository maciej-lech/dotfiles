#!/usr/bin/env bash
# worktrunk post-remove hook: kill the session of the removed worktree, named <repo>-<branch> like wt-open.sh and
# `tuios worktree new` do. Checks for .git, as `wt remove` run from inside a worktree leaves an empty placeholder
# directory behind.
# Args: <branch> <worktree path> <primary worktree path>
branch=$1 path=$2 primary=$3
[[ -n $branch && -n $primary && ! -e $path/.git ]] || exit 0
session=$(basename -- "$primary")-${branch//\//-}
tuios ls --json 2>/dev/null | jq -e --arg s "$session" '.[] | select(.name == $s)' >/dev/null || exit 0

# Killing the session a client shows would quit that client, so move it to the most recent other session first
other=$(tuios ls --json | jq -r --arg s "$session" '[.[] | select(.name != $s)] | sort_by(-.last_active) | .[0].name // empty')
if [[ -n $other ]] && tuios ls --json | jq -e --arg s "$session" '.[] | select(.name == $s and .attached)' >/dev/null; then
  tuios switch-session -s "$session" "$other" >/dev/null
fi
tuios kill-session "$session" >/dev/null
exit 0
