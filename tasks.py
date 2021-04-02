from invoke import Collection, task

from dotfiles import get_modules, invoke_execute


MODULES = get_modules()


@task(default=True)
def bootstrap(c):
    for module in MODULES:
        c.invoke_execute(c, module.__name__)


ns = Collection(bootstrap)
ns.configure({
    'root_namespace': ns,
    'invoke_execute': invoke_execute,
})
for module in MODULES:
    ns.add_collection(Collection.from_module(module))
