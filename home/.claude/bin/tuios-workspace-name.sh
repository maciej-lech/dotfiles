#!/usr/bin/env bash
# Name the tuios workspace after the running command when nothing named it yet, e.g.
# `tuios worktree new --agent claude` starts the agent without a shell, so the fish title hooks never run.
[ -n "$TUIOS_WINDOW_ID" ] && [ -n "$TUIOS_SESSION" ] || exit 0
command -v tuios >/dev/null || exit 0

IFS=$'\t' read -r ws pid fg cmdline < <(tuios list-windows -s "$TUIOS_SESSION" --json 2>/dev/null \
    | jq -r --arg id "$TUIOS_WINDOW_ID" '.windows[] | select(.window_id == $id)
        | [.workspace, .pid, .foreground_cmd // "", .running_cmdline // ""] | @tsv')
[ -n "$ws" ] || exit 0

name=$(tuios list-workspaces -s "$TUIOS_SESSION" --json 2>/dev/null \
    | jq -r --argjson ws "$ws" '.workspaces[] | select(.workspace == $ws) | .name')
[ -z "$name" ] || exit 0

if [ -z "$cmdline" ] && [ -r "/proc/$pid/cmdline" ]; then
    cmdline=$(tr '\0' ' ' <"/proc/$pid/cmdline")
fi
title="${cmdline:-$fg}"
title="${title#"${title%%[![:space:]]*}"}"
title="${title%"${title##*[![:space:]]}"}"
[ -n "$title" ] || exit 0
[ ${#title} -le 32 ] || title="${title:0:31}…"

tuios set-workspace-name -s "$TUIOS_SESSION" "$ws" "$title" >/dev/null 2>&1
exit 0
