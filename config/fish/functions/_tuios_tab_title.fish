# tuios labels an unnamed workspace with the OSC 1 icon name of its active pane, and a name set by hand wins
# over it, so no record of the last label is needed. A hook has no terminal on stdout: it passes the pane's tty
function _tuios_tab_title --argument-names title tty
    # A control character would end the sequence early
    set title (string replace --all --regex -- '[\x00-\x1f\x7f]' '' $title)
    if test -n "$tty"
        printf '\e]1;%s\a' $title >$tty
    else
        printf '\e]1;%s\a' $title
    end
end
