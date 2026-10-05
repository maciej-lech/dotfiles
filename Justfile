# Symlink every package into its target
stow:
    stow --target="$HOME" home
    stow --target="$HOME/.config" config
    stow --target="$HOME/.local" local
