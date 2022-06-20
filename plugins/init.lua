return {
    -- Themes
    {
        "murtaza-u/gruvqueen",
        config = function()
            require("user.plugins.config.gruvqueen_config")()
        end
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
        config = function()
            require("user.plugins.config.vim_better_whitespace_config")()
        end
    },
    { -- Discord RPC
        "andweeb/presence.nvim",
        config = function()
            require("user.plugins.config.presence_config")()
        end
    },
    { -- Rust crates info
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end
    },
    { -- Git integration
        "TimUntersberger/neogit",
        config = function()
            require("neogit").setup()
        end
    },
    { -- Github copilot
        "github/copilot.vim",
        event = { "BufRead", "BufNewFile" },
    }
}
