local setup = {
    rust_analyzer = function(opts)
        require("rust-tools").setup({
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
        })
    end,
    sumneko_lua = function(opts)
        opts = require("lua-dev").setup({
            lspconfig = opts
        })
        require("lspconfig").sumneko_lua.setup(opts)
    end
}

return function(server, opts)
    local setup_fn = setup[server]

    if setup_fn ~= nil then
        setup_fn(opts)
    end
end

