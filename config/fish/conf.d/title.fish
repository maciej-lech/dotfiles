status is-interactive || exit
set --query TMUX[1] || set --query HERDR_TAB_ID[1] || exit

function _tab_title --argument-names title
    if test -n "$TMUX"
        printf '\033k%s\033\\' $title
    end
    if test -n "$HERDR_TAB_ID"
        _herdr_tab_title $title
    end
end

function _tab_title_command --on-event fish_preexec
    # The shell is replaced or gone, so no prompt would ever set the title back
    string match --quiet --regex -- '^\s*(exec|exit)\b' $argv && return
    _tab_title (string trim -- $argv | string shorten -m 32)
end

function _tab_title_prompt --on-event fish_prompt
    _tab_title (string shorten -m 32 --left (prompt_pwd -d 1 -D 2))
end
