# Symlink every package into its target
stow:
    stow --target="$HOME" home
    stow --target="$HOME/.config" config
