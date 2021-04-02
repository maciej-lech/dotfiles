import os
from pathlib import Path


def make_backup(c, file):
    if file.exists() and not file.is_symlink():
        file_backup = Path('{}.orig'.format(file))
        if not file_backup.exists():
            c.run('mv -f {} {}'.format(file, file_backup))
            return True

    return False


def symlink(c, source, destination, backup=True):
    cwd = Path(Path.cwd(), c.cwd)
    destination = Path(destination).expanduser()
    # os.path.relpath is different than Path.relative_to which wouldn't work here
    source = os.path.relpath(Path(cwd, source), destination.parent)

    if backup:
        make_backup(c, destination)

    c.run('mkdir -p {}'.format(destination.parent))
    c.run('rm -f {}'.format(destination))
    with c.cd(destination.parent):
        c.run('ln -fs {} {}'.format(source, destination.name))
