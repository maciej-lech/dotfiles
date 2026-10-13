# Based on __fish_cache_sourced_completions from https://github.com/fish-shell/fish-shell
# Unlike the original, a failed run (e.g. a mise shim with no version set) keeps the previous cache intact

function __cached_completions --description 'Source generated completions, regenerating when the command binary changes'
    set -l cmd (command -s $argv[1])
    or return 127

    set -l dir $__fish_cache_dir/completions
    set -l compfile $dir/$argv[1].fish
    set -l stampfile $dir/$argv[1].stamp
    set -l mtime (path mtime -- $cmd)

    set -l stamp
    path is -rf -- $stampfile
    and read stamp <$stampfile

    if test "$stamp" != "$mtime"; or not test -s $compfile
        command mkdir -p $dir
        set -l tmp (command mktemp $compfile.XXXXXX)
        or return 1
        if $argv >$tmp 2>/dev/null; and test -s $tmp
            command mv -f $tmp $compfile
            echo $mtime >$stampfile
        else
            command rm -f $tmp
            return 2
        end
    end

    source $compfile
end
