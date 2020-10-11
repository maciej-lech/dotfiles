export PATH=/usr/lib/ccache:$HOME/.local/bin:$PATH
export ZSH="$HOME/.antigen/bundles/robbyrussell/oh-my-zsh/"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=14

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="/home/maciek/.zsh"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.zsh/custom/plugins/
plugins=(
)

# Antigen plugins manager
source $ZSH_CUSTOM/antigen/antigen.zsh

# for debian plugin
apt_pref='apt'

# for jira plugin
JIRA_URL='https://xxx.atlassian.net'
JIRA_DEFAULT_ACTION=dashboard

# for git (my custom modification)
ZSH_GIT_NOALIASES=1

# use ohmyz
antigen use oh-my-zsh

# bundle plugins
antigen bundles <<EOBUNDLES
    common-aliases
    command-not-found
    colored-man-pages
    dircycle
    debian
    django
    docker
    dotenv
    git
    history
    jira
    pip
    pyenv
    python
    sudo
    tmux
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    zsh-users/zsh-syntax-highlighting
    endaaman/lxd-completion-zsh
    greymd/tmux-xpanes
EOBUNDLES

# set theme and apply
antigen theme robbyrussell
antigen apply

# OMZ
. $ZSH/oh-my-zsh.sh

# PyEnv
export PATH="${HOME}/.pyenv/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# VirtualenvWrapper
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
# . "$(which virtualenvwrapper.sh)"

# Direnv
# eval "$(direnv hook zsh)"

# Powerline
if [ -f /usr/share/powerline/bindings/zsh/powerline.zsh ]; then
    . /usr/share/powerline/bindings/zsh/powerline.zsh
fi

# Perl setup
if [ -d /home/maciek/perl5/bin ]; then
    PATH="/home/maciek/perl5/bin${PATH:+:${PATH}}"; export PATH;
    PERL5LIB="/home/maciek/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
    PERL_LOCAL_LIB_ROOT="/home/maciek/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
    PERL_MB_OPT="--install_base \"/home/maciek/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=/home/maciek/perl5"; export PERL_MM_OPT;
fi

# Keychain
if [ -f /usr/bin/keychain ]; then
    eval "$(keychain -q --eval reef)"
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
