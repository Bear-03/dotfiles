-- Remove trailing spaces
return {
    "ntpeters/vim-better-whitespace",
    event = "User AstroFile",
    config = function()
        vim.g.better_whitespace_enabled = true
        vim.g.strip_whitespace_on_save = true
        vim.g.strip_whitespace_confirm = false
    end
}
