#!/usr/bin/env bash
# Plugin panes start in the plugin root, so pass the workspace directory explicitly.
cwd=$(jq -r '.workspace_cwd // .focused_pane_cwd // empty' <<<"$HERDR_PLUGIN_CONTEXT_JSON")
exec "$HERDR_BIN_PATH" plugin pane open --plugin "$HERDR_PLUGIN_ID" --entrypoint picker --cwd "${cwd:-$HOME}" --focus
