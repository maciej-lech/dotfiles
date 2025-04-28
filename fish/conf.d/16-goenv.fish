if test -d $HOME/.goenv && ! set -q IN_NIX_SHELL
    set -gx GOENV_ROOT $HOME/.goenv
    fish_add_path -P $GOENV_ROOT/bin
    goenv init - fish | source
    #fish_add_path -pP $GOROOT/bin
    fish_add_path -aP $GOPATH/bin
end
