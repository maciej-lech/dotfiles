## Functions

lockmount() {
    encfs -f $HOME/.Lock_encfs $HOME/Lock
#    fusermount -u Lock
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

# Apt
alias aptupd='sudo apt update'
alias aptupg='sudo apt upgrade'
alias aptfupg='sudo apt dist-upgrade'
alias aptins='sudo apt install'
alias aptrei='sudo apt reinstall'
alias aptpur='sudo apt purge --purge'
alias aptsch='apt search'
alias aptsho='apt show'
alias aptpol='apt policy'

alias aptlist='dpkg -l | grep ^ii | cut -d ' ' -f3 | tr '\n' ' ''
alias aptman="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"

# Misc
alias xo='xdg-open'
alias icons='gsettings set org.gnome.desktop.background show-desktop-icons true'
alias iconh='gsettings set org.gnome.desktop.background show-desktop-icons false'
alias synchtime='sudo ntpdate pl.pool.ntp.org'
alias sdh='sudo shutdown -h'
alias ppt2pdf='libreoffice --headless --invisible --convert-to pdf'

## WORK
# IDEs
alias eclipse='~/opt/eclipse/eclipse &'
alias clion='~/opt/clion-2016.3.3/bin/clion.sh &'
alias pycharm='~/opt/pycharm-2016.3.2/bin/pycharm.sh &'

# Grep
alias a=ack-grep

# Gerrit
alias gerrit='ssh -p 29418 maciek@192.168.123.131 gerrit'

