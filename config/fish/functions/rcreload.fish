function rcreload --description 'Reload fish config, including functions'
    for file in "$__fish_config_dir"/conf.d/*.fish
        source $file
    end

    source "$__fish_config_dir"/config.fish

    for file in "$__fish_config_dir"/functions/*.fish
        source $file
    end
end
