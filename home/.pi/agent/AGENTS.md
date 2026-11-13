# AGENTS.md

## Communication

* Always use `-` (dash) instead of `—` (em dash) in text output
* Break down features into clear tasks before implementing

## Editing files

* Always trim trailing whitespace in edited lines
* Always leave empty line at the end when you create a new file
* Keep code comments minimal; only explain non-standard patterns

## Shell

* Prefer `rg` over `grep`
* Prefer `fd` over `find`
* When you need to execute a command as root, use `pkexec` instead of `sudo`; do not change `sudo` usage in scripts or other files; but in documentation (Markdown or other docs) write `sudo` in example commands, not `pkexec`

## Git

* When committing, always write one-line messages
* Never add agent attribution (`Co-Authored-By:`, session or tool trailers) to commit messages or PR bodies
* If you need to download files that are already part of a Git repository, clone that repository to the `tmp/` (create if missing)

### Worktrees

* Outside tuios, use `wt` (worktrunk) for managing Git worktrees
* Inside tuios (`$TUIOS_SESSION` is set), use `tuios worktree` instead of `wt`
* Inside tuios, start an agent in a worktree with `tuios worktree new <branch> --base <base> --agent <agent> --detach --json`, then give it the task with `tuios queue -s <session> -w <window_id> '<task>'`; never use `delegate`, `fan`, `start-agent` or `tuios new` for this

## Privacy

* Never expose personal or identifying data (local username, home path like `/var/home/<user>`, hostname, email, IPs, serials) in anything public: GitHub issues, PRs, comments, gists, upstream reports, pasted logs; replace with `$HOME`, `~`, `user` or placeholders and scan every draft before posting
