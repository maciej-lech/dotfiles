# wt-picker

Herdr plugin that opens the [worktrunk](https://worktrunk.dev) picker (`wt switch`) in a popup and opens the chosen worktree as a Herdr space.

- `Enter` - switch to the selected worktree (creates one for branches without a worktree)
- `Alt-c` - create a new worktree named as the typed text
- `Alt-x` - remove the selected worktree
- `Esc` - close

New spaces are labeled with the branch name; the main worktree keeps the repository space. Spaces whose checkout no longer exists are closed when the picker exits and after `wt remove` / `wt merge` (via the worktrunk hook below).

## Requirements

- Herdr 0.7.4+
- [worktrunk](https://worktrunk.dev) (`wt`)
- `jq`
- `bash`

## Setup

Link the plugin:

```bash
herdr plugin link ~/.config/herdr/local-plugins/wt-picker
```

Bind the picker in `~/.config/herdr/config.toml` (this replaces Herdr's built-in new worktree dialog):

```toml
[keys]
new_worktree = ""

[[keys.command]]
key = "prefix+shift+g"
type = "plugin_action"
command = "wt-picker.open"
description = "Worktree: switch / create (wt picker)"
```

Add the cleanup hook to `~/.config/worktrunk/config.toml`, so spaces of worktrees removed outside the picker are closed:

```toml
[post-remove]
herdr = "herdr plugin action invoke cleanup --plugin wt-picker"
```

On server start the plugin checks for this hook and shows a notification when it is missing.

## Actions

- `wt-picker.open` - open the picker
- `wt-picker.cleanup` - close spaces whose worktree checkout no longer exists
