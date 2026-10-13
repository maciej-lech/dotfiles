status is-interactive || exit
set --query TMUX[1] || set --query HERDR_TAB_ID[1] || exit

function _tab_title --argument-names title
    if test -n "$TMUX"
        printf '\033k%s\033\\' $title
    end
    if test -n "$HERDR_TAB_ID" -a -n "$HERDR_BIN_PATH"
        _herdr_tab_title $title
    end
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

    # A job still in flight would race this one, so stop it first
    if set --query _herdr_tab_job[1] && path is -d /proc/$_herdr_tab_job
        command kill $_herdr_tab_job 2>/dev/null
    end

    fish --no-config --private --command '
        set --local title $argv[1]
        set --local previous $argv[2]
        set --local state $argv[3]
        set --local last
        test -n "$state" && test -r $state && read last <$state

        set --local info (command $HERDR_BIN_PATH tab get $HERDR_TAB_ID 2>/dev/null)
        or exit
        set --local label (string match --regex --groups-only -- "\"label\":\"([^\"]*)\"" $info)
        string match --quiet --regex -- "^\d+\$" $label || contains -- $label $last $previous
        or exit

        command $HERDR_BIN_PATH tab rename $HERDR_TAB_ID $title >/dev/null 2>&1
        or exit
        if test -n "$state"
            command mkdir -p (path dirname $state)
            echo $title >$state
        end
    ' -- $title $previous $state </dev/null >/dev/null 2>&1 &
    set --global _herdr_tab_job $last_pid
    disown $last_pid
end

function _tab_title_command --on-event fish_preexec
    # The shell is replaced or gone before a title job for these could be stopped
    string match --quiet --regex -- '^\s*(exec|exit)\b' $argv && return
    _tab_title (string shorten -m 32 $argv)
end

function _tab_title_prompt --on-event fish_prompt
    _tab_title (prompt_pwd -d 1 -D 2)
end
