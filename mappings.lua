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
