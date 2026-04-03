# nvim-claudehalp

Ask Claude what Neovim command or keymap to use, with your current keymaps and plugins as context.

## Requirements

- [Claude Code CLI](https://github.com/anthropics/claude-code) installed and authenticated

## Usage

```
:ClaudeHalp how do I save a file
:CH how do I split the window vertically
```

## Installation

With lazy.nvim:

```lua
{
  dir = "~/Documents/projects/nvim-claudehalp",
}
```
