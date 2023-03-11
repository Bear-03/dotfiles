-- Remove trailing spaces
return {
    "ntpeters/vim-better-whitespace",
    lazy = false,
    config = function()
        vim.g.better_whitespace_enabled = true
        vim.g.strip_whitespace_on_save = true
        vim.g.strip_only_modified_lines = true
        vim.g.strip_whitespace_confirm = false
    end
}
