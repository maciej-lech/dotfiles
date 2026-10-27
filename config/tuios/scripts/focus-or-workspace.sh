#!/usr/bin/env bash
# Like niri's focus-column-or-monitor: focus the neighbouring pane, or at the edge the nearest workspace with panes on that side
dir=$1 s=${TUIOS_SESSION:-}
wins=$(tuios list-windows ${s:+-s "$s"} --json)
ws=$(tuios list-workspaces ${s:+-s "$s"} --json)
cur=$(jq -r '.current_workspace' <<<"$ws")

# A pane overlapping the focused one vertically and lying past its edge, shared borders allowed for
neighbour=$(jq -r --arg d "$dir" --argjson c "$cur" '
  (.windows[] | select(.focused)) as $f
  | [.windows[] | select(.workspace == $c and (.minimized | not) and (.focused | not)
      and .y < $f.y + $f.height and .y + .height > $f.y
      and (if $d == "right" then .x >= $f.x + $f.width - 1 else .x + .width - 1 <= $f.x end))]
  | length' <<<"$wins" 2>/dev/null)

if [[ ${neighbour:-0} -gt 0 ]]; then
  tuios call focus-window "{\"session\":\"$s\",\"direction\":\"$dir\"}" >/dev/null 2>&1
  exit 0
fi

if [[ $dir == right ]]; then
  target=$(jq -r --argjson c "$cur" '[.workspaces[] | select(.window_count > 0 and .workspace > $c) | .workspace] | min // empty' <<<"$ws")
else
  target=$(jq -r --argjson c "$cur" '[.workspaces[] | select(.window_count > 0 and .workspace < $c) | .workspace] | max // empty' <<<"$ws")
fi
[[ -n $target ]] && tuios run-command ${s:+-s "$s"} SwitchWorkspace "$target" >/dev/null
exit 0
