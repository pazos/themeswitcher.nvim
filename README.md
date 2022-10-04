# themeswitcher.nvim

A dead simple theme switcher for neovim.

Mostly useless unless you're me or you like to switch themes as much as I like :p

## Installation

With `packer`

```lua
    use { "pazos/themeswitcher.nvim",
        requires = {
            -- put some themes here
            "Mofiqul/vscode.nvim",
            "tanvirtin/monokai.nvim",
            "NTBBloodbath/doom-one.nvim",
        },
    }
```

Of course you don’t need to put your themes as dependencies of this plugin but it makes your `plugins.lua` a bit more tidy :)


## Configuration

```lua
require("themeswitcher").setup {
    colorscheme = "vscode",
    silent = "false",
    system = { included = { "lunaperche" }},
    installed = { excluded = { "monokai", "monokai_ristretto" }},
}
```

You might want to setup keybindings for `ThemeNext` and `ThemePrevious`, so you can easily switch between them.
