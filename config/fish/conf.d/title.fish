status is-interactive || exit
set --query TMUX[1] || set --query HERDR_TAB_ID[1] || exit

function _tab_title --argument-names title
    if test -n "$TMUX" && not _tmux_workmux_window
        printf '\033k%s\033\\' $title
    end
    if test -n "$HERDR_TAB_ID"
        _herdr_tab_title $title
    end
end

# workmux finds its windows by name, so a title rename breaks it; it marks them with @workmux_token
function _tmux_workmux_window
    set --query _tmux_workmux_window && return 0
    test -n "$(command tmux show-options -wqv -t $TMUX_PANE @workmux_token 2>/dev/null)"
    or return 1
    set --global _tmux_workmux_window 1
end

# herdr keeps OSC titles to itself, so rename the tab through its CLI in the background, only while the
# tab still has its generated position number or the label set here last (a manual rename is left alone)
function _herdr_tab_title --argument-names title
    test "$title" = "$_herdr_tab_title" && return
    set --local previous $_herdr_tab_title
    set --global _herdr_tab_title $title

    set --local state
    if set --query XDG_RUNTIME_DIR[1]
        set state $XDG_RUNTIME_DIR/herdr-tab-titles/(string replace --all : _ $HERDR_TAB_ID)
    end

    # Killing a job in flight leaves its herdr call running to land late, so each job waits for the one before
    fish --no-config --private --command '
        while test -n "$argv[4]" && path is -d /proc/$argv[4]
            sleep 0.05
        end
        set --local title $argv[1]
        set --local previous $argv[2]
        set --local state $argv[3]
        set --local last
        test -n "$state" && test -r $state && read last <$state

        # HERDR_BIN_PATH is a versioned brew path that disappears on upgrade while the server keeps running
        set --local herdr $HERDR_BIN_PATH
        test -x "$herdr" || set herdr (command -s herdr)
        or exit

        set --local info (command $herdr tab get $HERDR_TAB_ID 2>/dev/null)
        or exit
        set --local label (string match --regex --groups-only -- "\"label\":\"([^\"]*)\"" $info)
        # herdr (and tuios) trim the label, so compare trimmed
        string match --quiet --regex -- "^\d+\$" $label || contains -- $label (string trim -- $last $previous)
        or exit

        command $herdr tab rename $HERDR_TAB_ID $title >/dev/null 2>&1
        or exit
        if test -n "$state"
            command mkdir -p (path dirname $state)
            echo $title >$state
        end
    ' -- "$title" "$previous" "$state" "$_herdr_tab_job" </dev/null >/dev/null 2>&1 &
    set --global _herdr_tab_job $last_pid
    disown $last_pid
end

function _tab_title_command --on-event fish_preexec
    # The shell is replaced or gone, so no prompt would ever set the title back
    string match --quiet --regex -- '^\s*(exec|exit)\b' $argv && return
    _tab_title (string trim -- $argv | string shorten -m 32)
end

function _tab_title_prompt --on-event fish_prompt
    _tab_title (string shorten -m 32 --left (prompt_pwd -d 1 -D 2))
end
