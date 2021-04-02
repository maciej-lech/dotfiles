from invoke import Executor
from invoke.main import program


def invoke_execute(c, command, **kwargs):
    results = Executor(c.root_namespace, config=c.config, core=program.core).execute((command, kwargs))
    target_task = c.root_namespace[command]
    return results[target_task]
