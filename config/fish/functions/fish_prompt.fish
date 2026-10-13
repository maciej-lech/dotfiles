# Based on https://github.com/jorgebucaran/hydro
# Copyright (c) Jorge Bucaran, MIT License: https://github.com/jorgebucaran/hydro/blob/main/LICENSE.md

function fish_prompt --description 'Write out the prompt'
    echo -e -n "$_prompt_color_start$prompt_symbol_start$prompt_color_normal$_prompt_color_pwd$_prompt_pwd$prompt_color_normal $_prompt_color_git$$_prompt_git$prompt_color_normal$_prompt_color_duration$_prompt_cmd_duration$prompt_color_normal$_prompt_status$prompt_color_normal "
end
