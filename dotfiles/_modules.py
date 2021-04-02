from importlib import import_module
from pathlib import Path


def iter_modules(path=None):
    if path is None:
        path = Path.cwd()

    for directory in path.iterdir():
        if directory.name != 'dotfiles' and Path(directory, '__init__.py').exists():
            yield import_module(directory.name)


def get_modules(path=None):
    return list(iter_modules(path=path))
