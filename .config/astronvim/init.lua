-- NOTE: Toggleterm can be open with "<leader>t"

return {
    colorscheme = "gruvqueen", -- is broken with vimscript themes
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
        }
    },
}

