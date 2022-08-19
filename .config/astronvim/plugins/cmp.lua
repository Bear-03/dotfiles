return function(config)
    local cmp = require("cmp")

    return vim.tbl_deep_extend("force", config, {
        mapping = {
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }
    })
end
