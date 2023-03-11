-- LSP support for Nu
return {
    "LhKipp/nvim-nu",
    event = "BufRead *.nu",
    build = ":TSInstall nu",
}
