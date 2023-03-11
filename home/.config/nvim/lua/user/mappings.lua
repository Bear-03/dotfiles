return {
    n = {
        ["<leader>gg"] = { "<cmd>Neogit<CR>", desc = "Neogit" },
        -- Better navigation
        ["<S-l>"] = {
            function()
                require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
            end,
            desc = "Next buffer",
        },
        ["<S-h>"] = {
            function()
                require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
            end,
            desc = "Previous buffer",
        },
    },
    t = {
        ["<esc>"] = { "<C-\\><C-n>", desc = "Terminal normal mode" },
    },
}
