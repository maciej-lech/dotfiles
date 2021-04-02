from invoke import task

from dotfiles import symlink


@task(default=True)
def bootstrap(c):
    with c.cd('vim'):
        symlink(c, 'vimrc', '~/.vimrc')
