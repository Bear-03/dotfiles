-- TODO: FIX THIS PROPERLY (Not copying and pasting code from the AstroNvim source)
return {
    {
        hl = { fg = "fg", bg = "NONE" },
        astronvim.status.component.mode(),
        astronvim.status.component.git_branch({ hl = { bg = "NONE" } }),
        astronvim.status.component.file_info(
            astronvim.is_available "bufferline.nvim" and
            { filetype = {}, filename = false, file_modified = false, hl = { bg = "NONE" } } or
            nil
        ),
        astronvim.status.component.git_diff({ hl = { bg = "NONE" } }),
        astronvim.status.component.diagnostics({ hl = { bg = "NONE" } }),
        astronvim.status.component.fill(),
        astronvim.status.component.macro_recording({ hl = { bg = "NONE" } }),
        astronvim.status.component.fill(),
        astronvim.status.component.lsp({ hl = { bg = "NONE" } }),
        astronvim.status.component.treesitter({ hl = { bg = "NONE" } }),
        astronvim.status.component.nav({ hl = { bg = "NONE" } }),
        astronvim.status.component.mode { surround = { separator = "right" } },
    },
    {
        fallthrough = false,
        {
            condition = function()
                return astronvim.status.condition.buffer_matches {
                    buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                    filetype = { "NvimTree", "neo-tree", "dashboard", "Outline", "aerial" },
                }
            end,
            init = function() vim.opt_local.winbar = nil end,
        },
        {
            condition = astronvim.status.condition.is_active,
            astronvim.status.component.breadcrumbs { hl = { fg = "winbar_fg", bg = "NONE" } },
        },
        astronvim.status.component.file_info {
            file_icon = { highlight = false },
            hl = { fg = "winbarnc_fg", bg = "NONE" },
            surround = false,
        },
    },
}
