# herdr keeps OSC titles to itself, so rename the tab through its CLI in the background, only while the
# tab still has its generated position number or the label set here last (a manual rename is left alone)
function _herdr_tab_title --argument-names title
    test "$title" = "$_herdr_tab_title" && return
    set --local previous $_herdr_tab_title
    set --global _herdr_tab_title $title

    # Not in XDG_RUNTIME_DIR: tuios resurrects tab labels after a reboot, the state must outlive it too
    set --local state_dir $XDG_STATE_HOME
    set --query state_dir[1] || set state_dir ~/.local/state
    set state_dir $state_dir/herdr-tab-titles

    # Killing a job in flight leaves its herdr call running to land late, so each job waits for the one before
    fish --no-config --private --command '
        while test -n "$argv[4]" && path is -d /proc/$argv[4]
            sleep 0.05
        end
        set --local title $argv[1]
        set --local previous $argv[2]

        # HERDR_BIN_PATH is a versioned brew path that disappears on upgrade while the server keeps running
        set --local herdr $HERDR_BIN_PATH
        test -x "$herdr" || set herdr (command -s herdr)
        or exit

        # HERDR_TAB_ID is fixed at shell start: stale after a pane moves, and tuios gives a resurrected pane
        # the workspace number instead of its tab key, so ask herdr for the tab of the pane now
        set --local tab (command $herdr pane get $HERDR_PANE_ID 2>/dev/null | string match --regex --groups-only -- "\"tab_id\":\"([^\"]+)\"")[1]
        set --query tab[1] || set tab $HERDR_TAB_ID
        set --local state $argv[3]/(string replace --all : _ $tab)
        set --local last
        test -r $state && read last <$state

        set --local info (command $herdr tab get $tab 2>/dev/null)
        or exit
        set --local label (string match --regex --groups-only -- "\"label\":\"([^\"]*)\"" $info)
        # herdr (and tuios) trim the label, so compare trimmed
        string match --quiet --regex -- "^\d+\$" $label || contains -- $label (string trim -- $last $previous)
        or exit

        command $herdr tab rename $tab $title >/dev/null 2>&1
        or exit
        command mkdir -p (path dirname $state)
        echo $title >$state
    ' -- "$title" "$previous" "$state_dir" "$_herdr_tab_job" </dev/null >/dev/null 2>&1 &
    set --global _herdr_tab_job $last_pid
    disown $last_pid
end
