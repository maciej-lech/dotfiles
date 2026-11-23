#!/bin/sh
# SessionStart hook: run herdr's agent-state integration, only inside herdr.
# tuios sets HERDR_ENV too (it speaks herdr's protocol), so TUIOS_ENV marks a tuios pane.

[ -n "${HERDR_ENV:-}" ] && [ -z "${TUIOS_ENV:-}" ] || exit 0
exec bash "$HOME/.claude/hooks/herdr-agent-state.sh" session
