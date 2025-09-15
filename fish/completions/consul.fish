
function __complete_consul
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    /home/linuxbrew/.linuxbrew/bin/consul
end
complete -f -c consul -a "(__complete_consul)"
