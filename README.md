# nvim-aqua

Neovim plugin to detect macOS appearance change. I use it with themes and
other plugins that observe `background`, like with [Monokai NighTasty](https://github.com/polirritmico/monokai-nightasty.nvim) and some of the [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) themes.

## Install and Setup

Install using your favourite Neovim package manager.

```lua
{
  "rancorm/nvim-aqua",
  config = function()
    require("nvim-aqua").setup {
      change = function(value)
        -- Note the comparison is done with a string not an integer
        if value == "1" then
          -- Light
          vim.opt.background = "light"
        else
          -- Dark
          vim.opt.background = "dark"
        end
      end
    }
  
    vim.notify("nvim-aqua loaded", "info", { title = "nvim-aqua" })
  end
}
```

## Observer

This plugin comes with a Swift script, observer.swift, which watches for macOS
appearance changes.

This script runs when the plugin does and prints a `1` (light) or `0` (dark) to 
standard out when changes are detected.

The Lua portion of the plugin that spawns the script, uses a callback to handle
the output and pass the value, `1` or `0`, to the user change function. Where the
user can make use of it.
