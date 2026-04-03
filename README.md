# 😵‍💫 nvim-claudehalp

[![LuaRocks](https://img.shields.io/luarocks/v/dskart/nvim-claudehalp?style=flat-square&color=blue)](https://luarocks.org/modules/dskart/nvim-claudehalp)
[![Release](https://img.shields.io/github/actions/workflow/status/dskart/nvim-claudehalp/release-please.yml?style=flat-square&label=release)](https://github.com/dskart/nvim-claudehalp/actions/workflows/release-please.yml)
[![Neovim](https://img.shields.io/badge/Neovim-0.10+-green?style=flat-square&logo=neovim)](https://neovim.io)

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
  "dskart/nvim-claudehalp",
}
```
