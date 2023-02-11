local function mappings()
    -- Disables arrow keys in modes where hjkl are available
    vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", { noremap = true })
    vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", { noremap = true })
    vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", { noremap = true })
    vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", { noremap = true })

    -- Block CTRL-Z on Windows (It freezes the console)
    if vim.loop.os_uname().sysname == "Windows_NT" then
        vim.keymap.set({ "", "!" }, "<C-z>", "<Nop>", { noremap = true })
    end

    -- Treat wrapped lines as normal lines with j and k
    -- Note: for simplicity, this is only set to work with
    -- j and k, so dd, yy etc won't work
    vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
end

return function()
    if vim.fn.has("termguicolors") == 1 then
        vim.opt.termguicolors = true
    end

    -- Change LSP message prefix
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            prefix = "●"
        }
    })

    -- Force English
    vim.cmd([[
        for s:lang in ["en", "en_US", "en_US.UTF-8", "English_US"]
            try
                execute "language ".s:lang
                break
            catch /^Vim(language):E197:/
                " Do nothing
            endtry
        endfor
    ]])

    -- Trailing whitespace highlight group (used in themes.lua)
    vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])

    -- File associations
    vim.filetype.add({
        extension = {
            x68 = "m68k",
            X68 = "m68k",
            rasi = "css",
        },
    })

    mappings()
end
