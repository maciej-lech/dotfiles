if command -q fzf
    fzf --fish | source

    set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --exclude .git . $dir'
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git . $dir'
    set -gx FZF_DEFAULT_COMMAND "$FZF_CTRL_T_COMMAND"
    set -gx FZF_CTRL_T_OPTS '--preview "bat -n --color=always --line-range :500 {}"'
    set -gx FZF_ALT_C_OPTS '--preview "eza --tree --group-directories-first --level 2 --color=always {} | head -200"'
    set -gx FZF_CTRL_R_OPTS '--preview "echo '{}'"'
    set -gx FZF_DEFAULT_OPTS "$FZF_CTRL_T_OPTS"
end
