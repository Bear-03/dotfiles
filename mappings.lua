-- Disables arrow keys in modes where hjkl are available
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", { noremap = true })

-- Delete buffer
vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { noremap = true })
