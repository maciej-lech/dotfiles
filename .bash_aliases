### .bash_aliases

# Basic
alias s='sudo'
alias c='clear'
alias e='exit'
alias t='tmux'

alias '..'='cd ..'
alias 'cd..'='cd ..'
alias 'cd...'='cd ../..'
alias 'cd....'='cd ../../..'
alias 'll'='ls -la'
alias 'lr'='ls -lr'

# Grep
alias greph='history | grep'

# Apt
alias aptupd='sudo apt-get update'
alias aptupg='sudo apt-get upgrade'
alias aptfupg='sudo apt-get dist-upgrade'
alias aptins='sudo apt-get install'
alias aptrei='sudo apt-get reinstall'
alias aptpur='sudo apt-get purge --purge'
alias aptsch='apt-cache search'
alias aptsho='apt-cache show'
alias aptpol='apt-cache policy'

#alias applist='dpkg -l | grep ^ii | cut -d ' ' -f3 | tr '\n' ' ''

# Yaourt
#alias ysyn='yaourt -Sy'
#alias yupg='yaourt -Syu'
#alias yins='yaourt -S'
#alias yrem='yaourt -Rs'
#alias ypur='yaourt -Rns'
#alias ysch='yaourt -Ss'
#alias yinf='yaourt -Si'

# Emacs
alias e='emacs -mm'
alias es='emacs-snapshot -mm'

# Misc
alias xo='xdg-open'
alias icons='gsettings set org.gnome.desktop.background show-desktop-icons true'
alias iconh='gsettings set org.gnome.desktop.background show-desktop-icons false'
alias synchtime='sudo ntpdate pl.pool.ntp.org'
alias sdh='sudo shutdown -h'
alias ppt2pdf='libreoffice --headless --invisible --convert-to pdf'

alias pi='libreoffice --nologo --show ~/praca_inz/prezentacja.odp'

