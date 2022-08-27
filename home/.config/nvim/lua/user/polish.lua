local function shebang_to_filetype(associations)
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            local shebang = vim.fn.getline(1)

            for pattern, filetype in pairs(associations) do
                if shebang:match(pattern) then
                    vim.bo.filetype = filetype;
                end
            end
        end
    })
end

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

    -- Trailing whitespace highlight group (used in themes.lua)
    vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            vim.lsp.buf.formatting_sync(nil, 1000)
        end
    })

    -- File associations
    vim.filetype.add({
        extension = {
            x68 = "m68k",
            X68 = "m68k"
        },
    })

    -- Shebang set filetype
    shebang_to_filetype({
        ["[ /]nu$"] = "nu",
    })

    mappings()
    require("user.themes")
end


