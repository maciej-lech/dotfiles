# Based on https://github.com/jorgebucaran/hydro
# Copyright (c) Jorge Bucaran, MIT License: https://github.com/jorgebucaran/hydro/blob/main/LICENSE.md

status is-interactive || exit

set --global _prompt_git _prompt_git_$fish_pid
set --global _prompt_git_seq 0

# Async git status goes through a file in $XDG_RUNTIME_DIR plus SIGUSR1, so killed shells leave nothing
# in fish_variables; without a usable runtime dir, fall back to a per-shell universal variable
set --global _prompt_git_file
if set --query XDG_RUNTIME_DIR[1] && path is -d -w -- $XDG_RUNTIME_DIR
    set --local dir $XDG_RUNTIME_DIR/fish-prompt
    if path is -d -w -- $dir || command mkdir -m 700 $dir 2>/dev/null
        set _prompt_git_file $dir/$fish_pid
    end
end

function $_prompt_git --on-variable $_prompt_git
    commandline --function repaint
end

if test -n "$_prompt_git_file"
    function _prompt_git_ready --on-signal SIGUSR1
        read --line --local seq value <$_prompt_git_file 2>/dev/null
        or return
        test "$seq" = "$_prompt_git_seq" && set --global $_prompt_git $value
    end
end

function _prompt_pwd --on-variable PWD --on-variable prompt_ignored_git_paths --on-variable prompt_pwd_dir_length --on-variable prompt_pwd_dir_levels
    if test "$prompt_pwd_dir_length" = 0
        set --global _prompt_pwd (path basename $PWD)
        return
    end

    set --local dir (string replace --regex -- "^$(string escape --style=regex -- ~)" '~' $PWD)
    set --local parts (string split / $dir)
    set --local total (count $parts)

    set --local shortened
    for i in (seq 1 $total)
        if test $i -le (math $total - $prompt_pwd_dir_levels)
            set --append shortened (string replace --regex -- "(\.?[^/]{$prompt_pwd_dir_length}).*" '$1' $parts[$i])
        else
            set --append shortened $parts[$i]
        end
    end

    set --global _prompt_pwd (
        string join / $shortened |
            string replace --regex -- '([^/]+)$' "\x1b[1m\$1\x1b[22m" |
            string replace --regex --all -- '(?!^/$)/|^$' "\x1b[2m/\x1b[22m"
    )
end

function _prompt_postexec --on-event fish_postexec
    set --local last_status $pipestatus
    set --global _prompt_status "$_prompt_newline$_prompt_color_symbol$prompt_symbol"

    for code in $last_status
        if test $code -ne 0
            set --global _prompt_status "$_prompt_color_error"(echo $last_status)" $_prompt_newline$_prompt_color_symbol$_prompt_color_error$prompt_symbol"
            break
        end
    end

    test "$CMD_DURATION" -lt $prompt_cmd_duration_threshold && set _prompt_cmd_duration && return

    set --local secs (math --scale=1 $CMD_DURATION/1000 % 60)
    set --local mins (math --scale=0 $CMD_DURATION/60000 % 60)
    set --local hours (math --scale=0 $CMD_DURATION/3600000)

    set --local out

    test $hours -gt 0 && set --local --append out $hours"h"
    test $mins -gt 0 && set --local --append out $mins"m"
    test $secs -gt 0 && set --local --append out $secs"s"

    set --global _prompt_cmd_duration "$out "
end

function _prompt_update --on-event fish_prompt
    set --query _prompt_status || set --global _prompt_status "$_prompt_newline$_prompt_color_symbol$prompt_symbol"
    set --query _prompt_pwd || _prompt_pwd

    command kill $_prompt_last_pid 2>/dev/null
    set _prompt_git_seq (math $_prompt_git_seq + 1)

    set --local git_root (command git --no-optional-locks rev-parse --show-toplevel 2>/dev/null)

    if ! set --query git_root[1] || contains -- "$git_root" $prompt_ignored_git_paths
        set $_prompt_git
        return
    end

    set --local --export _prompt_git_current $$_prompt_git
    set --local --export _prompt_git_job_seq $_prompt_git_seq
    set --local --export _prompt_git_job_file $_prompt_git_file
    set --local --export _prompt_git_parent $fish_pid

    fish --private --command "
        function _publish
            if test -z \"\$_prompt_git_job_file\"
                set --universal $_prompt_git \"\$argv\"
                return
            end
            set --local tmp \$_prompt_git_job_file.\$fish_pid
            printf '%s\\n%s\\n' \$_prompt_git_job_seq \"\$argv\" >\$tmp && command mv -f \$tmp \$_prompt_git_job_file || return
            # SIGUSR1 terminates non-fish processes, so never signal a reused pid
            if test -r /proc/\$_prompt_git_parent/comm
                read --local comm </proc/\$_prompt_git_parent/comm
                test \"\$comm\" = fish || return
            end
            command kill -s USR1 \$_prompt_git_parent 2>/dev/null
        end

        set branch (
            command git branch --show-current 2>/dev/null ||
            command git describe --tags --exact-match HEAD 2>/dev/null ||
            command git rev-parse --short HEAD 2>/dev/null |
                string replace --regex -- '(.+)' '@\$1'
        )

        test -z \"\$_prompt_git_current\" && _publish \"\$branch \"

        command git diff-index --quiet HEAD 2>/dev/null
        test \$status -eq 1 ||
            count (command git ls-files --others --exclude-standard (command git rev-parse --show-toplevel)) >/dev/null && set info \"$prompt_symbol_git_dirty\"

        for fetch in $prompt_fetch false
            command git rev-list --count --left-right @{upstream}...@ 2>/dev/null |
                read behind ahead

            switch \"\$behind \$ahead\"
                case \" \" \"0 0\"
                case \"0 *\"
                    set upstream \"$prompt_symbol_git_ahead\$ahead\"
                case \"* 0\"
                    set upstream \"$prompt_symbol_git_behind\$behind\"
                case \*
                    set upstream \"$prompt_symbol_git_ahead\$ahead$prompt_symbol_git_behind\$behind\"
            end

            set -l _status \"\$info\$upstream\"
            test -n \"\$_status\" && set _status \":\$_status\"
            _publish \"\$branch\$_status \"

            test \$fetch = true && command git fetch --no-tags 2>/dev/null
        end
    " &

    set --global _prompt_last_pid $last_pid
end

function _prompt_fish_exit --on-event fish_exit
    set --erase $_prompt_git
    if test -n "$_prompt_git_file"
        command kill $_prompt_last_pid 2>/dev/null
        command rm -f $_prompt_git_file
    end
end

set --global prompt_color_normal (set_color normal)

for color in prompt_color_{pwd,git,error,symbol,duration,start}
    function $color --on-variable $color --inherit-variable color
        set --query $color && set --global _$color (set_color $$color)
    end && $color
end

function prompt_multiline --on-variable prompt_multiline
    if test "$prompt_multiline" = true
        set --global _prompt_newline "\n"
    else
        set --global _prompt_newline ""
    end
end && prompt_multiline

set --query prompt_color_error || set --global prompt_color_error $fish_color_error
set --query prompt_symbol || set --global prompt_symbol ❱
set --query prompt_symbol_git_dirty || set --global prompt_symbol_git_dirty •
set --query prompt_symbol_git_ahead || set --global prompt_symbol_git_ahead ↑
set --query prompt_symbol_git_behind || set --global prompt_symbol_git_behind ↓
set --query prompt_multiline || set --global prompt_multiline false
set --query prompt_pwd_dir_levels || set --global prompt_pwd_dir_levels 3
set --query prompt_pwd_dir_length || set --global prompt_pwd_dir_length 1
set --query prompt_cmd_duration_threshold || set --global prompt_cmd_duration_threshold 1000
