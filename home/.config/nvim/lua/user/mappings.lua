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
        -- Open alpha dashboard if no other buffers are left
        ["<leader>c"] = {
            function()
                local bufs = vim.fn.getbufinfo({ buflisted = true })
                require("astronvim.utils.buffer").close(0)

                if require("astronvim.utils").is_available("alpha-nvim") and not bufs[2] then
                    require("alpha").start(true)
                end
            end,
            desc = "Close buffer",
        },
    },
    t = {
        ["<esc>"] = { "<C-\\><C-n>", desc = "Terminal normal mode" },
    },
}
