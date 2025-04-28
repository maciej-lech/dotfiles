# https://github.com/fish-shell/fish-shell/issues/5699

function _tmux-pane-title-command --on-event fish_preexec
    if test -n "$TMUX"
        set title (string shorten -m 32 $argv)
        printf "\033k$title\033\\"
    end
end

function _tmux-pane-title-prompt --on-event fish_prompt
    if test -n "$TMUX"
        set title (prompt_pwd -d 1 -D 2)
        printf "\033k$title\033\\"
    end
end
