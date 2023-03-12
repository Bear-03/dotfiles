return {
    { import = "astrocommunity.pack.rust" },
    {
        "rust-tools.nvim",
        opts = {
            tools = {
                inlay_hints = {
                    show_parameter_hints = false,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },
        }
    }
}
