return {
    -- Themes
    {
        "sainnhe/gruvbox-material",
        config = require("user.plugins.gruvbox_material")
    },
    -- Lsp
    { -- Better rust support (inlay hints etc)
        "simrat39/rust-tools.nvim",
        after = { "nvim-lspconfig" },
    },
    { -- neovim API autocompletion for lua
        "folke/lua-dev.nvim",
        after = { "nvim-lspconfig" },
    },
    -- Treesitter
    {
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },
    -- Other
    {
        "ntpeters/vim-better-whitespace", -- Highlight trailing spaces
        event = { "BufRead", "BufNewFile" },
        config = require("user.plugins.vim_better_whitespace")
    },
    {
        "andweeb/presence.nvim",
        config = require("user.plugins.presence")
    },
    {
        "saecki/crates.nvim", -- Rust crates info
        requires = { "nvim-lua/plenary.nvim" },
        event = { "BufRead Cargo.toml" },
    }
}
