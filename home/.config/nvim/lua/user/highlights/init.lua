return function()
    return {
        Normal = { bg = "NONE", ctermbg = "NONE" },
        NormalNC = { bg = "NONE", ctermbg = "NONE" },
        CursorColumn = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
        CursorLine = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
        CursorLineNr = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
        LineNr = {},
        SignColumn = {},
        NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" },
        NormalFloat = { bg = "NONE", ctermbg = "NONE" },
        FloatBorder = { bg = "NONE" }, -- Floating window borders (e.g. PackerSync, LSP)
        EndOfBuffer = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
        NeoTreeEndOfBuffer = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
    }
end
