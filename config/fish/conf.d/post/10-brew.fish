if test -d /home/linuxbrew/.linuxbrew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source
    # Keep brew after system binaries so its dependencies (dbus, curl, mount...) don't shadow them
    fish_add_path --global --move --append --path $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin
end
