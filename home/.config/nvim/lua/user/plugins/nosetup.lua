-- Small plugins that require no configuration
return {
    -- Astronvim community repository
    {
        "AstroNvim/astrocommunity"
    },
    { import = "astrocommunity.utility.noice-nvim" },
    {
        "noice.nvim",
        opts = {
            views = {
                mini = {
                    border = {
                        style = "rounded",
                    },
                    win_options = {
                        winblend = 0
                    }
                },
            },
        }
    },
    -- Treesitter debugging
    {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
    },
    -- Git integration
    {
        "TimUntersberger/neogit",
        cmd = "Neogit",
    },
}
