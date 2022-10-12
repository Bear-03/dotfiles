return {
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
    server = astronvim.lsp.server_settings("rust_analyzer")
}
