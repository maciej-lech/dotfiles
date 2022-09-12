## Functions

lockmount() {
    encfs -f $HOME/.Lock_encfs $HOME/Lock
}

## Aliases

# Basic
alias s='sudo'
alias c='clear'
alias e='exit'

# Shells
alias rcreload='. ~/.zshrc'
alias t='tmux'

# Grep and find
alias grepi='grep -i'
alias grepr='grep -r'
alias grepir='grep -ir'
alias findf='find . -name'
alias a=ack-grep

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

# Python
alias pip-upgrade-all='pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U'
alias pip-uninstall-all='pip uninstall -y -r <(pip freeze)'
alias pip-uninstall-all-local='pip uninstall -y -r <(pip freeze -l)'

alias pe=pyenv

# Editors
alias st=subl

# Docker
alias doc=docker
alias docc=docker-compose

# Misc
alias xo='xdg-open'
alias synchtime='sudo ntpdate pl.pool.ntp.org'
alias sdh='sudo shutdown -h'
alias ppt2pdf='libreoffice --headless --invisible --convert-to pdf'
