return function ()
    local style = "original"

    require("gruvqueen").setup({
        config = {
            style = style,
            bg_color = "#1d2021",
        },
    })

    local palette = require("gruvqueen.palette").get_dark_theme_palette()
    local common_palette = palette.common
    local style_palette = palette[style]

    vim.api.nvim_set_hl(0, "TSParameter", { fg = style_palette.blue })
    vim.api.nvim_set_hl(0, "TSField", { fg = style_palette.fg0 }) -- Attributes
    -- -- vim.api.nvim_set_hl(0, "TSFunction", { fg = style_palette.fg0 })
    vim.api.nvim_set_hl(0, "TSConstant", { link = "TSNumber" })
    vim.api.nvim_set_hl(0, "TSConstBuiltin", { link = "TSConstant" })
    vim.api.nvim_set_hl(0, "TSVariableBuiltin", { fg = common_palette.grey1 }) -- ex. self / this
    vim.api.nvim_set_hl(0, "rustTSPunctBracket", { fg = style_palette.red }) -- For closures in rust
    vim.api.nvim_set_hl(0, "TSOperator", { fg = style_palette.aqua })
end
