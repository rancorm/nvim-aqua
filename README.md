# nvim-aqua

Neovim plugin to detect macOS appearance change. I use it with themes and
other plugins that observe `background`, like with [Monokai NighTasty](https://github.com/polirritmico/monokai-nightasty.nvim) and some of the [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) themes.

> [!NOTE]
> There is a linking issue with Swift scripts on macOS Sonoma. The workaround
> requires the Xcode toolchain, sorry.

## Install and Setup

Install using your favourite Neovim package manager. What my [lazy.nvim](https://github.com/folke/lazy.nvim) plugin config
looks like:

```lua
return {
  "rancorm/nvim-aqua",
  lazy = false, -- Make sure to load this plugin during startup
  priority = 1000, -- Make sure to load this before all other start plugins
  version = "0.x",
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
  end
}
```

Or if you would like, you can use the `light` and `dark` functions.

```lua
return {
  "rancorm/nvim-aqua",
  lazy = false, -- Make sure to load this plugin during startup
  priority = 1000, -- Make sure to load this before all other start plugins
  version = "0.x",
  config = function()
    require("nvim-aqua").setup {
      light = function()
        vim.opt.background = "light"
      end,
      dark = function()
        vim.opt.background = "dark"
      end
    }
  end
}
```

## Observer

The plugin includes a Swift script, [observer.swift](scripts/observer.swift), designed to monitor macOS
appearance changes.

The script is triggered under specific conditions (e.g., on
startup or during certain events) and outputs either `1` (light mode) or `0` (dark mode)
to standard output when changes are detected.

The Lua component of the plugin is responsible for launching the Swift script and
employs a callback mechanism to handle the script's output. The callback function
receives the value (1 or 0) and passes it to a user-defined function, allowing users
to incorporate the information as needed.
