# CLAUDE.md

* Always use `caveman` plugin
* Always use `-` (dash) instead of `—` (em dash) in text output
* Always trip white characters in edited lines
* Always leave empty line at the end when you create a new file
* Prefer `rg` over `grep`
* Prefer `fd` over `find`
* Use `wt` (worktrunk) for managing Git worktrees
* If you need to download file(s) that is already part of Git repository, clone that repository to the `tmp/` (create if missing)
* Break down features into clear tasks before implementing
* When commiting, always write a oneline messages
* Never add `Claude-Session:`, `Co-Authored-By: Claude` or any other Claude attribution to commit messages or PR bodies
* Keep code comments minimal; only explain non-standard patterns
* When you need to execute a command as root, use `pkexec` instead of `sudo`; do not change `sudo` usage in scripts or other files; but in documentation (Markdown or other docs) write `sudo` in example commands, not `pkexec`
* Never publish Artifacts or upload anything to claude.ai; deliver reports and documents as local files in the repository, and do not offer to publish them
