return function ()
    local style = "original"

    require("gruvqueen").setup({
        config = {
            style = style,
            bg_color = "#1d2021",
        },
    })

    -- Palette comes split into common, material, mix and original
    local split_palette = require("gruvqueen.palette").get_dark_theme_palette()
    local palette = vim.tbl_deep_extend("force", split_palette.common, split_palette[style])

    vim.api.nvim_set_hl(0, "TSVariable", { fg = palette.blue })
    vim.api.nvim_set_hl(0, "TSParameter", { fg = palette.blue })
    vim.api.nvim_set_hl(0, "TSField", { fg = palette.fg0 }) -- Attributes
    -- vim.api.nvim_set_hl(0, "TSFunction", { fg = palette.fg0 })
    vim.api.nvim_set_hl(0, "TSConstant", { link = "TSNumber" })
    vim.api.nvim_set_hl(0, "TSConstBuiltin", { link = "TSConstant" })
    vim.api.nvim_set_hl(0, "TSVariableBuiltin", { fg = palette.grey1 }) -- ex. self / this
    vim.api.nvim_set_hl(0, "rustTSPunctBracket", { fg = palette.red }) -- For closures in rust
    vim.api.nvim_set_hl(0, "TSOperator", { fg = palette.aqua })
end
