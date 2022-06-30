return function(server, opts)
    if server == "rust_analyzer" then
        local custom_opts = {
            tools = {
                inlay_hints = {
                    show_parameter_hints = false,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },
            server = vim.tbl_deep_extend("force", opts, {
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = {
                            disabled = { "inactive-code" },
                        }
                    }
                }
            }),
        }

        -- Lspconfig has to be set up before rust-tools
        require("lspconfig")[server].setup(opts)
        require("rust-tools").setup(custom_opts)
        return

    elseif server == "sumneko_lua" then
        opts = require("lua-dev").setup({
            lspconfig = opts
        })
        require("lspconfig")[server].setup(opts)
    end
end

