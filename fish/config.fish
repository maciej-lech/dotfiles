# config.fish

# The order of sourcing conf.d is ackward: https://github.com/fish-shell/fish-shell/issues/8553
# Use use our own custom source loop to be able to specify the order.
for file in "$__fish_config_dir"/conf.d/post/*.fish
    source $file
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
