return {
    -- Disabled
    ["Darazaki/indent-o-matic"] = { disable = true },

    -- Themes
    {
        "sainnhe/gruvbox-material"
    },
    -- Lsp
    { -- Better rust support (inlay hints etc)
        "simrat39/rust-tools.nvim",
        after = "mason-lspconfig.nvim",
        ft = { "rust" },
        config = function()
            require("rust-tools").setup(require("user.plugins.rust-tools"))
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
            require("presence"):setup(require("user.plugins.presence"))
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
