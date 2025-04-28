## Abbreviations

# Basic
abbr -a -- s sudo
abbr -a -- c clear
abbr -a -- e exit

# System commands
abbr -a -- .. 'cd ..'
abbr -a -- ... 'cd ../..'
abbr -a -- .... 'cd ../../..'
abbr -a -- ..... 'cd ../../../..'

# Git
abbr -a -- g git

# Apt
abbr -a -- aptupd 'sudo apt update'
abbr -a -- aptupg 'sudo apt upgrade'
abbr -a -- aptfupg 'sudo apt dist-upgrade'
abbr -a -- aptins 'sudo apt install'
abbr -a -- aptrei 'sudo apt reinstall'
abbr -a -- aptpur 'sudo apt purge --purge'
abbr -a -- aptaut 'sudo apt autoremove'
abbr -a -- aptsch 'apt search'
abbr -a -- aptsho 'apt show'
abbr -a -- aptpol 'apt policy'

# Snap
abbr -a -- snapref 'sudo snap refresh'
abbr -a -- snapins 'sudo snap install'
abbr -a -- snaprem 'sudo snap remove'
abbr -a -- snapfin 'snap find'

# Flatpak
abbr -a -- flatupd 'sudo flatpak update'
abbr -a -- flatins 'sudo flatpak install'
abbr -a -- flatuni 'sudo flatpak uninstall'
abbr -a -- flatsch 'flatpak search'

# Python
abbr -a -- pe 'pyenv'

# Golang
abbr -a -- ge 'goenv'

# Docker
abbr -a -- doc docker
abbr -a -- docc 'docker compose'

# Hashistack
abbr -a -- no nomad
abbr -a -- co consul
abbr -a -- va vault
abbr -a -- tf terraform

# Task
abbr -a -- t task

# Misc
abbr -a -- xo xdg-open
