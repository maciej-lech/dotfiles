#!/usr/bin/env bash
# Kill sessions of removed worktrunk worktrees: those wt-open.sh recorded, and those whose panes all sit in
# <repo>/.worktrees/<name> without .git. Checks for .git, as `wt remove` run from inside a worktree leaves an
# empty placeholder directory behind.
state=${XDG_STATE_HOME:-$HOME/.local/state}/tuios-wt-picker/sessions
sessions=$(tuios ls --json 2>/dev/null | jq -r '.[].name') || exit 0

# Killing the session a client shows would quit that client, so move it to the most recent other session first
kill_session() {
  local other
  other=$(tuios ls --json | jq -r --arg s "$1" '[.[] | select(.name != $s)] | sort_by(-.last_active) | .[0].name // empty')
  if [[ -n $other ]] && tuios ls --json | jq -e --arg s "$1" '.[] | select(.name == $s and .attached)' >/dev/null; then
    tuios switch-session -s "$1" "$other" >/dev/null
  fi
  tuios kill-session "$1" >/dev/null
}

if [[ -f $state ]]; then
  keep=$(mktemp)
  while IFS=$'\t' read -r s path; do
    grep -qxF -- "$s" <<<"$sessions" || continue
    if [[ -e $path/.git ]]; then
      printf '%s\t%s\n' "$s" "$path" >>"$keep"
    else
      kill_session "$s"
    fi
  done <"$state"
  mv "$keep" "$state"
fi

tuios ls --json 2>/dev/null | jq -r '.[].name' | while read -r s; do
  cwds=$(tuios list-windows -s "$s" --json | jq -r '.windows[].cwd')
  [[ -n $cwds ]] || continue
  gone=true
  while read -r cwd; do
    cwd=${cwd% (deleted)}
    if [[ ! $cwd =~ ^(.*/\.worktrees/[^/]+) ]] || [[ -e ${BASH_REMATCH[1]}/.git ]]; then
      gone=false
      break
    fi
  done <<<"$cwds"
  if $gone; then
    kill_session "$s"
  fi
done
exit 0
