return {
    -- Themes
    {
        "murtaza-u/gruvqueen",
    },
    -- Lsp
    { -- Better rust support (inlay hints etc)
        "simrat39/rust-tools.nvim",
    },
    { -- Neovim API autocompletion for lua
        "folke/lua-dev.nvim",
    },
    { -- Nu support (Nushell)
        "LhKipp/nvim-nu",
        run = ":TSInstall nu",
        config = function()
            require("nu").setup({})
        end
    },
    -- Treesitter
    { -- Treesitter debugging
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },
    -- Other
    {
        "lewis6991/spaceless.nvim",
        config = function()
            require("spaceless").setup()
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
}
