return function()
    if vim.fn.has("termguicolors") == 1 then
        vim.opt.termguicolors = true
    end

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

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            vim.lsp.buf.formatting_sync(nil, 1000)
        end
    })

    -- Fix weird blue-ish background in NeoTree for modified files
    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { link = "Blue" })

    -- File associations
    vim.filetype.add {
        extension = {
            x68 = "m68k",
            X68 = "m68k"
        },
    }
end

