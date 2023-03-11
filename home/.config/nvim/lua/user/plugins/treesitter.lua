return {
    "nvim-treesitter",
    dependencies = {
        "HiPhish/nvim-ts-rainbow2",
    },
    opts = {
        rainbow = {
            enable = true,
            hlgroups = {
                "Red",
                "Yellow",
                "Blue",
                "Orange",
                "Green",
                "Purple",
                "Aqua",
            }
        }
    }
}
