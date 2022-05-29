return function()
    vim.opt.background = "dark"

    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_palette = "original"

    local function gruvbox_material_custom()
        vim.api.nvim_set_hl(0, "TSVariable", { link = "Blue" })
        vim.api.nvim_set_hl(0, "TSParameter", { link = "Blue" })
        vim.api.nvim_set_hl(0, "TSField", { link = "Fg" }) -- Attributes
        -- vim.api.nvim_set_hl(0, "TSFunction", { link = "Yellow" })
        vim.api.nvim_set_hl(0, "TSConstant", { link = "TSNumber" })
        vim.api.nvim_set_hl(0, "TSConstBuiltin", { link = "TSConstant" })
        vim.api.nvim_set_hl(0, "TSVariableBuiltin", { link = "Grey" }) -- ex. self / this
        vim.api.nvim_set_hl(0, "rustTSPunctBracket", { link = "Red" }) -- For closures in rust
        vim.api.nvim_set_hl(0, "TSOperator", { link = "Aqua" })
    end

    local GruvboxMaterialCustom = vim.api.nvim_create_augroup("GruvboxMaterialCustom", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox-material",
        callback = gruvbox_material_custom,
        group = GruvboxMaterialCustom,
    })

    vim.cmd("colorscheme gruvbox-material")
end
