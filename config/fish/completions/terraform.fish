# Self-completion adds subcommands missing from fish's static file; defined first so the static descriptions win
complete -c terraform -f -a '(__complete_comp_line terraform)'
source $__fish_data_dir/completions/terraform.fish
