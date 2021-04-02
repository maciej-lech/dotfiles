from invoke import task

from dotfiles import symlink


@task(default=True)
def bootstrap(c):
    with c.cd('bash'):
        symlink(c, 'bashrc', '~/.bashrc')
        symlink(c, 'bash_aliases', '~/.bash_aliases')
