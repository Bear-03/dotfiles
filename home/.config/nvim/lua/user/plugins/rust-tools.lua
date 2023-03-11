return {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    event = "User AstroLspSetup",
    opts = {
        tools = {
            inlay_hints = {
                show_parameter_hints = false,
                parameter_hints_prefix = "",
                other_hints_prefix = "",
            },
        },
        server = require("astronvim.utils.lsp").config("rust_analyzer")
    }
}
