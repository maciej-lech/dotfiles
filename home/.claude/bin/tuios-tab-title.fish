#!/usr/bin/env fish
# SessionStart hook: label the tuios pane with the command line of the claude process above this hook.
# A hook has no terminal on stdout, so the title goes to the pane's tty.

set --query TUIOS_ENV[1] TUIOS_PANE_TTY[1] || exit 0

set --local p $fish_pid
while set p (string replace --regex --filter '^PPid:\s+' '' </proc/$p/status) && test "$p" -gt 1
    if test (cat /proc/$p/comm) = claude
        _tuios_tab_title "$(string split0 </proc/$p/cmdline | string join ' ' | string shorten -m 32)" $TUIOS_PANE_TTY
        break
    end
end
exit 0
