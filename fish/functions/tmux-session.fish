function tmux-session --description 'TMUX session helper'
    command tmux new-session -A -s $argv
end
