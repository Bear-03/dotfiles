return {
    "nvim-cmp",
    opts = function(_, opts)
        local cmp = require("cmp")

        opts.mapping = {
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }
    end
}
