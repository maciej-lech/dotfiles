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

# Remember which worktree a session is for, so wt-cleanup.sh can close it after the worktree is removed
if [[ $path != "$primary" ]]; then
  state=${XDG_STATE_HOME:-$HOME/.local/state}/tuios-wt-picker
  mkdir -p "$state"
  { awk -F'\t' -v s="$session" '$1 != s' "$state/sessions" 2>/dev/null; printf '%s\t%s\n' "$session" "$path"; } >"$state/sessions.new"
  mv "$state/sessions.new" "$state/sessions"
fi

exec tuios switch-session "$session" --create --cwd "$path" >/dev/null
