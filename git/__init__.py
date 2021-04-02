from invoke import task

from dotfiles import symlink


@task(default=True)
def bootstrap(c):
    with c.cd('git'):
        symlink(c, 'gitconfig', '~/.gitconfig')
        symlink(c, 'gitattributes', '~/.gitattributes')
