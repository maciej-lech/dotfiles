#!/usr/bin/env bash
# Silence the memsearch plugin's "[memsearch] Memory available" UserPromptSubmit hint.
# The hint is a systemMessage (user-visible only) and has no config/env toggle, so
# patch every installed plugin version in place. Idempotent; run from SessionStart
# so it re-applies after plugin updates.

set -u

PLUGIN_GLOB="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/cache/memsearch-plugins/memsearch/*/hooks/user-prompt-submit.sh"
HINT_LINE='echo '\''{"systemMessage": "[memsearch] Memory available"}'\'''

for f in $PLUGIN_GLOB; do
  [ -f "$f" ] || continue
  grep -qxF "$HINT_LINE" "$f" || continue
  sed -i 's|^echo '\''{"systemMessage": "\[memsearch\] Memory available"}'\''$|echo '\''{}'\''|' "$f"
done

exit 0
