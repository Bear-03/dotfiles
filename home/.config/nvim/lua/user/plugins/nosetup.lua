-- Small plugins that require no configuration
return {
    -- Exit strings and delimiters with TAB
    {
        "abecodes/tabout.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
        },
        config = true,
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
