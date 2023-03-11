return {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
        local status = require("astronvim.utils.status")

        -- print(vim.inspect(opts))

        local file_info = status.component.tabline_file_info()
        file_info[7].provider = ""                                -- Remove close button from file info

        opts.tabline[2] = status.heirline.make_buflist(file_info) -- Build buffer tab for each file
    end
}
