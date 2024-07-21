## Functions

lockmount() {
    encfs -f $HOME/.Lock_encfs $HOME/Lock
}

openvpn-client() {
    systemctl $1 openvpn-client@$2
}

## Aliases

# Basic
alias s='sudo'
alias c='clear'
alias e='exit'

# System commands
alias ls='ls --group-directories-first --color=tty -v'
alias tree='tree --dirsfirst'

# Shells
alias rcreload='. ~/.zshrc'
alias tmux-default='tmux new-session -A -s 0'

# Grep and find
alias grepi='grep -i'
alias grepr='grep -r'
alias grepir='grep -ir'

# Git
alias g='git'

# Apt
alias aptupd='sudo apt update'
alias aptupg='sudo apt upgrade'
alias aptfupg='sudo apt dist-upgrade'
alias aptins='sudo apt install'
alias aptrei='sudo apt reinstall'
alias aptpur='sudo apt purge --purge'
alias aptaut='sudo apt autoremove'
alias aptsch='apt search'
alias aptsho='apt show'
alias aptpol='apt policy'

alias aptlist="dpkg -l | grep ^ii | cut -d ' ' -f3 | tr '\n' ' '"
alias aptman="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"

# Snap
alias snapref='sudo snap refresh'
alias snapins='sudo snap install'
alias snaprem='sudo snap remove'
alias snapfin='snap find'

# Python
alias pip-uninstall-all='pip uninstall -y -r <(pip freeze)'
alias pip-uninstall-all-local='pip uninstall -y -r <(pip freeze -l)'

alias pe=pyenv

# Editors
alias st='subl -a'

# Docker
alias doc=docker
alias docc='docker compose'

# Misc
alias xo='xdg-open'
alias synchtime='sudo ntpdate pl.pool.ntp.org'
