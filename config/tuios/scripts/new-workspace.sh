#!/bin/sh
# TODO: remove when a tuios release after v0.11.1 ships Gaurav-Gosain/tuios#1189, then bind new_workspace = ["c"] again
# Opens a pane on the first empty workspace and focuses it; the workspace is not empty when tuios switches, so terminal mode is kept
set -eu
ws=$(tuios list-workspaces --json ${TUIOS_SESSION:+-s "$TUIOS_SESSION"} | jq -r '[.workspaces[] | select(.window_count == 0) | .workspace] | first // empty')
if [ -z "$ws" ]; then
  exit 0
fi
id=$(tuios new-window ${TUIOS_SESSION:+-s "$TUIOS_SESSION"} --workspace "$ws" ${TUIOS_ACTIVE_PANE_CWD:+--cwd "$TUIOS_ACTIVE_PANE_CWD"} --print-id)
tuios call focus-window "{\"session\":\"${TUIOS_SESSION:-}\",\"window\":\"$id\"}" >/dev/null
