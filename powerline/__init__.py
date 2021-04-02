from invoke import task

from dotfiles import symlink


@task(default=True)
def bootstrap(c):
    with c.cd('powerline'):
        symlink(c, 'powerline', '~/.config/powerline')
