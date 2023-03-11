return {
    "heirline.nvim",
    opts = function(_, opts)
        local status = require("astronvim.utils.status")

        local file_info = status.component.tabline_file_info()
        file_info[7].provider = "" -- Remove close button from file info

        -- Build buffer tab for each file
        opts.tabline[2] = status.heirline.make_buflist(file_info)
        -- Remove lsp server loading info (fidget will show it instead)
        table.remove(opts.statusline[9][2][1][1], 1)
    end
}
