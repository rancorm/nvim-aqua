# nvim-aqua

Neovim plugin to detect macOS appearance change.

## Install and Setup

Install using your favourite Neovim package manager.

```lua
{
  "rancorm/nvim-aqua",
  name = "nvim-aqua",
  init = function()
    local aqua = require("nvim-aqua").setup {
      change = function(value)
    	if value == "1" then
          -- Light
	      vim.cmd("colorscheme github_light")
	      vim.opt.background = "light"
        else
          -- Dark
	      vim.cmd("colorscheme github_dark")
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
