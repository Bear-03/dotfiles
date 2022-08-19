-- Disables arrow keys in modes where hjkl are available
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", { noremap = true })

-- Delete buffer
vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { noremap = true })

-- Block CTRL-Z on Windows (It freezes the console)
if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.keymap.set({ "", "!" }, "<C-z>", "<Nop>", { noremap = true })
end

-- Neogit mapping (Overrides toggle-term LazyGit binding)
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { noremap = true })

-- Treat wrapped lines as normal lines with j and k
-- Note: for simplicity, this is only set to work with
-- j and k, so dd, yy etc won't work
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
