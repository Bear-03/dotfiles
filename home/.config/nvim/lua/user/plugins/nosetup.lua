-- Small plugins that require no configuration
return {
    -- Treesitter debugging
    {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
    },
    -- Git integration
    {
        "TimUntersberger/neogit",
        lazy = false,
    },
    -- Rust crates info
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}
