function ls --wraps ls --description "List contents of directory"
    if command -q eza
        command eza -g --group-directories-first $argv
    else
        command ls --group-directories-first --color=tty -hv $argv
    end
end
