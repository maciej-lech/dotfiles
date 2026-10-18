#!/usr/bin/env bash
# Warn when worktrunk's post-remove hook doesn't call our cleanup action
config=${WORKTRUNK_CONFIG_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/worktrunk/config.toml}
hook="herdr plugin action invoke cleanup --plugin wt-picker"

command -v wt >/dev/null || exit 0
grep -qF "$hook" "$config" 2>/dev/null && exit 0

"$HERDR_BIN_PATH" notification show "wt-picker: worktrunk hook missing" \
  --body "Add to $config: [post-remove] herdr = \"$hook\"" >/dev/null
