#!/usr/bin/env bash
# Stable wrapper around the caveman plugin's statusline script.
# Plugin lives under ~/.claude/plugins/cache/<marketplace>/<plugin>/<commit-hash>/,
# so the hash-bearing path changes on every plugin update. This wrapper resolves
# the newest installed version at runtime, keeping settings.json stable.

set -eu

PLUGIN_GLOB="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/cache/caveman/caveman/*/src/hooks/caveman-statusline.sh"

# shellcheck disable=SC2086
target=$(ls -1dt $PLUGIN_GLOB 2>/dev/null | head -n 1 || true)

[ -z "$target" ] && exit 0
[ ! -f "$target" ] && exit 0

exec bash "$target"
