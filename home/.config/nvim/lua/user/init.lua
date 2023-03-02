return {
    colorscheme = "gruvbox-material",
    options = {
        opt = {
            virtualedit = "onemore",
            mouse = "", -- Disable mouse
            clipboard = "", -- Disconnect vim and sytem clipboards
            smartcase = true,

            -- Tab settings
            expandtab = true, -- Always use spaces instead of TABS
            tabstop = 4, -- The width of a TAB is set to 4
            shiftwidth = 4, -- Indents will have a width of 4
            softtabstop = 4, -- Sets the number of columns for TABS

            -- Text wrap
            wrap = true,
            linebreak = true, -- Break at spaces
            breakindent = true, -- Keep indentation on break
            breakindentopt = "sbr",
        },
        g = {
            gruvbox_material_foreground = "original",
            c_syntax_for_h = 1,
        },
    },
    mappings = {
        n = {
            ["<leader>gg"] = { "<cmd>Neogit<CR>", desc = "Neogit" },
        },
        t = {
            ["<esc>"] = { "<C-\\><C-n>", desc = "Terminal normal mode" },
        },
    },
}
