## Completion functions

_ssh_hosts_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local hosts
	hosts=$(	grep '^Host' ~/.ssh/config ~/.ssh/config.d/* .ssh/generated/config.d/*  2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2- | tr ' ' '\n' | tr -s '\n' '\n')
    # Deduplicate hosts and create completion options
    COMPREPLY=( $(compgen -W "$(echo "$hosts" | sort -u)" -- "$cur") )
}
