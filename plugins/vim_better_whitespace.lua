return function()
    vim.g.strip_whitespace_on_save = 1
    vim.g.strip_only_modified_lines = 1
    vim.g.strip_whitespace_confirm = 0 -- Do not ask for confirmation
end

