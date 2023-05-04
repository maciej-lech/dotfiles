from invoke import task

from dotfiles import symlink


@task(default=True)
def bootstrap(c):
    with c.cd('zsh'):
        symlink(c, 'zshrc', '~/.zshrc')
        symlink(c, 'zprofile', '~/.zprofile')
        symlink(c, 'aliases.zsh', '~/.zsh/aliases.zsh')
