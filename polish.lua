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
        }
    )

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

    -- Mappings
    vim.keymap.set({ "", "!" }, "<Left>", "<Nop>", { noremap = true })
    vim.keymap.set({ "", "!" }, "<Right>", "<Nop>", { noremap = true })
    vim.keymap.set({ "", "!" }, "<Up>", "<Nop>", { noremap = true })
    vim.keymap.set({ "", "!" }, "<Down>", "<Nop>", { noremap = true })

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            vim.lsp.buf.formatting_sync(nil, 1000)
        end
    })

    -- File associations
    vim.filetype.add {
        extension = {
            x68 = "m68k",
            X68 = "m68k"
        },
    }
end

