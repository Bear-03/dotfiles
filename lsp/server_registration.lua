return function(server, opts)
    if server == "rust_analyzer" then
        local custom_opts = {
            tools = {
                hover_with_actions = true,
                inlay_hints = {
                    show_parameter_hints = false,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },
        }

        require("rust-tools").setup(vim.tbl_deep_extend("force", opts, custom_opts))
        return

    elseif server == "sumneko_lua" then
        opts = require("lua-dev").setup({
            lspconfig = opts
        })
    end

    require("lspconfig")[server].setup(opts)
end

