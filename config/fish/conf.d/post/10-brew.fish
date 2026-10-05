if test -d /home/linuxbrew/.linuxbrew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source
    # Keep brew after system binaries so its dependencies (dbus, curl, mount...) don't shadow them
    fish_add_path --global --move --append --path $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin
end

if command -q brew
    set HOMEBREW_COMMAND_NOT_FOUND_HANDLER $HOMEBREW_REPOSITORY/Library/Homebrew/command-not-found/handler.fish
    if test -f $HOMEBREW_COMMAND_NOT_FOUND_HANDLER
        source $HOMEBREW_COMMAND_NOT_FOUND_HANDLER
    end
end
