return function(server, opts)
    if server == "rust_analyzer" then
        local custom_opts = {
            tools = {
                inlay_hints = {
                    hover_with_actions = true,
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

        require("rust-tools").setup(custom_opts)
        return

    elseif server == "sumneko_lua" then
        opts = require("lua-dev").setup({
            lspconfig = opts
        })
    end

    require("lspconfig")[server].setup(opts)
end

