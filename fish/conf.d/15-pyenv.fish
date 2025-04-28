if test -d $HOME/.pyenv && ! set -q IN_NIX_SHELL
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path -P $PYENV_ROOT/bin
    pyenv init - fish | source
    pyenv virtualenv-init - fish | source
end
