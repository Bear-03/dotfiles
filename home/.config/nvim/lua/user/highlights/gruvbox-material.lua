return function()
    local config = vim.fn["gruvbox_material#get_configuration"]()
    local palette = vim.tbl_map(function(color) return color[1] end,
        vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
    )

    return {
        -- Treesitter
        ["@constant"] = { link = "@number" },
        ["@variable.builtin"] = { fg = palette.grey1 }, -- ex. self / this
        ["@punctuation.bracket"] = { fg = palette.red }, -- For closures in rust
        ["@operator"] = { fg = palette.aqua },

        -- NvimTree
        NeoTreeGitConflict = { fg = palette.purple },
        NeoTreeGitUntracked = { fg = palette.orange },

        -- Prompt menu (e.g. LSP autocompletion menu)
        PmenuThumb = { bg = palette.fg0 }, -- Scroll indicator

        -- BetterWhitespace
        ExtraWhitespace = { bg = palette.red },
    }
end
