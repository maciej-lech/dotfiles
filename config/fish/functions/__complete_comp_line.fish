function __complete_comp_line --description 'Complete CLIs that read COMP_LINE (HashiCorp, posener/complete)'
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    command $argv[1] 2>/dev/null
end
