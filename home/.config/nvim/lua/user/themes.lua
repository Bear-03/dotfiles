local configs = {
    gruvqueen = function()
        local style = "original"

        require("gruvqueen").setup({
            config = {
                disable_bold = true,
                style = style,
                bg_color = "#1d2021",
            },
        })

        -- Palette comes split into common, material, mix and original
        local split_palette = require("gruvqueen.palette").get_dark_theme_palette()
        local palette = vim.tbl_deep_extend("force", split_palette.common, split_palette[style])

        local custom_hl = {
            -- Treesitter
            TSVariable = { fg = palette.blue },
            TSParameter = { fg = palette.blue },
            TSField = { fg = palette.fg0 }, -- Attributes
            -- TSFunction = { fg = palette.fg0 },
            TSConstant = { link = "TSNumber" },
            TSConstBuiltin = { link = "TSConstant" },
            TSVariableBuiltin = { fg = palette.grey1 }, -- ex. self / this
            rustTSPunctBracket = { fg = palette.red }, -- For closures in rust
            TSOperator = { fg = palette.aqua },

            -- Other
            VertSplit = { fg = palette.bg1 }, -- Vertical splits (e.g. NeoTree border)
            FloatBorder = { fg = palette.fg0, bg = palette.bg1 }, -- Floating window borders (e.g. PackerSync)

            -- Prompt menu (e.g. LSP autocompletion menu)
            PmenuThumb = { bg = palette.fg0 }, -- Scroll indicator

            -- Custom
            TrailingWhitespace = { bg = palette.red },
        }
    end
}

configs[vim.g.colors_name]()
