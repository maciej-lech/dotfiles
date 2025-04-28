
function __complete_terragrunt
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    /nix/store/1inzgyp5n2abvvm939krcd2xjdhvbwd9-terragrunt-0.72.6/bin/terragrunt
end
complete -f -c terragrunt -a "(__complete_terragrunt)"

