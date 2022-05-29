return {
    -- Themes
    {
        "sainnhe/gruvbox-material",
        config = require("user.plugins.custom.gruvbox_material")
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
        config = require("user.plugins.custom.vim_better_whitespace")
    },
    { -- Discord RPC
        "andweeb/presence.nvim",
        config = require("user.plugins.custom.presence")
    },
    { -- Rust crates info
        "saecki/crates.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        event = { "BufRead Cargo.toml" },
    },
    { -- Github copilot
        "github/copilot.vim",
        event = { "BufRead", "BufNewFile" },
    }
}
