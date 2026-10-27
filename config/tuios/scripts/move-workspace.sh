#!/bin/sh
# TODO: remove when Gaurav-Gosain/tuios#1217 is fixed, then bind move_workspace_left/right again
# Swap the current workspace with its neighbour; works around tuios 0.11.1 move_workspace_* dropping moves
set -eu
delta=$1
ws=$(tuios list-workspaces --json ${TUIOS_SESSION:+-s "$TUIOS_SESSION"})
cur=$(printf '%s' "$ws" | jq -r '.current_workspace')
to=$((cur + delta))
printf '%s' "$ws" | jq -e --argjson to "$to" '.workspaces[] | select(.workspace == $to and .window_count > 0)' >/dev/null || exit 0
if [ "$delta" -lt 0 ]; then order="[$cur,$to]"; else order="[$to,$cur]"; fi
tuios call set-workspace-order "{\"session\":\"${TUIOS_SESSION:-}\",\"order\":$order}" >/dev/null
