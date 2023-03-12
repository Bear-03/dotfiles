-- Small plugins that require no configuration
return {
    -- Astronvim community repository
    {
        "AstroNvim/astrocommunity"
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
