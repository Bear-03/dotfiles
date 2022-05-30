return {
    -- Themes
    {
        "murtaza-u/gruvqueen",
        config = require("user.plugins.config.gruvqueen_config")
    },
    -- Lsp
    { -- Better rust support (inlay hints etc)
        "simrat39/rust-tools.nvim",
        after = { "nvim-lspconfig" },
    },
    { -- Neovim API autocompletion for lua
        "folke/lua-dev.nvim",
        after = { "nvim-lspconfig" },
    },
    -- Treesitter
    { -- Treesitter debugging
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },
    -- Other
    {
        "ntpeters/vim-better-whitespace", -- Highlight trailing spaces
        event = { "BufRead", "BufNewFile" },
        config = require("user.plugins.config.vim_better_whitespace_config")
    },
    { -- Discord RPC
        "andweeb/presence.nvim",
        config = require("user.plugins.config.presence_config")
    },
    { -- Rust crates info
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        requires = { "nvim-lua/plenary.nvim" },
    },
    { -- Github copilot
        "github/copilot.vim",
        event = { "BufRead", "BufNewFile" },
    }
}
