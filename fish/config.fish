# config.fish

# The order of sourcing conf.d is ackward: https://github.com/fish-shell/fish-shell/issues/8553
# Use use our own custom source loop to be able to specify the order.
for file in "$__fish_config_dir"/conf.d/post/*.fish
    source $file
end

if status is-interactive
    # Commands to run in interactive sessions can go here

    # In distrobox container, re-define our own fish_prompt function.
    # Distrobox defines its own in /etc/fish/conf.d/distrobox_config.fish
    if set -q DISTROBOX_ENTER_PATH
        set -g hydro_symbol_start "📦 "
        source "$__fish_config_dir"/functions/fish_prompt.fish
    end
end
