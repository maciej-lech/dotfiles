if command -q brew
    set HOMEBREW_COMMAND_NOT_FOUND_HANDLER (brew --repository)/Library/Homebrew/command-not-found/handler.fish
    if test -f $HOMEBREW_COMMAND_NOT_FOUND_HANDLER
        source $HOMEBREW_COMMAND_NOT_FOUND_HANDLER
    end

    set -p fish_complete_path /home/linuxbrew/.linuxbrew/share/fish/vendor_completions.d
end
