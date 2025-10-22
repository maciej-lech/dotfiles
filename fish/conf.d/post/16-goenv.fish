if command -q goenv && ! set -q IN_NIX_SHELL
    set -gx GOENV_ROOT $HOME/.goenv
    set -gx GOENV_PATH_ORDER "front"
    fish_add_path -P $GOENV_ROOT/bin
    goenv init - fish | source
end
