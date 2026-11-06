#!/usr/bin/env bash
# Called by `wt switch -x` with: <branch> <worktree path> <primary worktree path>
branch=$1 path=$(realpath -- "$2") primary=$(realpath -- "$3")

session=$(tuios ls --json | jq -r '.[].name' | while read -r s; do
  tuios list-windows -s "$s" --json | jq -r '.windows[].cwd' | while read -r cwd; do
    [[ $(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) == "$path" ]] && echo "$s"
  done
done | head -n1)

if [[ -z $session ]]; then
  # The main worktree is the repo's own session; linked ones follow tuios worktree naming
  session=$(basename -- "$primary")
  [[ $path != "$primary" ]] && session+="-${branch//\//-}"
fi

exec tuios switch-session "$session" --create --cwd "$path" >/dev/null
