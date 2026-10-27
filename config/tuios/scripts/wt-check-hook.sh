#!/usr/bin/env bash
# Warn when worktrunk's post-remove hook doesn't call wt-cleanup.sh
config=${WORKTRUNK_CONFIG_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/worktrunk/config.toml}

command -v wt >/dev/null || exit 0
grep -qF "tuios/scripts/wt-cleanup.sh" "$config" 2>/dev/null && exit 0

tuios run-command ${TUIOS_SESSION_ID:+-s "$TUIOS_SESSION_ID"} ShowNotification \
  "wt-picker: worktrunk hook missing. Add to $config: [post-remove] tuios = \"~/.config/tuios/scripts/wt-cleanup.sh\"" warning >/dev/null
