function fish_remove_path --description 'Remove paths from PATH'
    argparse -x g,U -x P,U g/global U/universal P/path v/verbose n/dry-run h/help -- $argv
    or return

    if set -q _flag_help
        __fish_print_help fish_remove_path
        return 0
    end

    # Determine variable scope (universal by default unless global or PATH used)
    set -l scope $_flag_global $_flag_universal
    if not set -q scope[1]; and not set -q fish_user_paths
        set scope -U
    end

    # Target variable: fish_user_paths or PATH
    set -l var fish_user_paths
    set -q _flag_path
    and set var PATH
    # PATH is always global
    and set scope -g

    # Enable verbose mode automatically if interactive
    status current-command | string match -rq '^fish_remove_path$'
    and isatty stdout
    and set -l _flag_verbose yes

    # Collect valid removal targets
    set -l remove_paths
    for path in $argv
        set -l p (builtin realpath -s -- $path 2>/dev/null)
        if not test -e "$p"
            if set -q _flag_verbose
                printf (_ "Skipping non-existent path: %s\n") "$path"
            end
            continue
        end
        set -a remove_paths $p
    end

    set -l oldvar $$var
    set -l newvar

    for p in $oldvar
        if contains -- $p $remove_paths
            if set -q _flag_verbose
                printf (_ "Removing path: %s\n") "$p"
            end
            continue
        end
        set -a newvar $p
    end

    if set -q _flag_verbose; or set -q _flag_n
        echo (string escape -- set $scope $var $newvar)
    end

    if not set -q _flag_n
        set $scope $var $newvar
    end

    if not set -q remove_paths[1]
        if set -q _flag_verbose
            printf (_ "No paths to remove.\n")
        end
        return 1
    end

    return 0
end
