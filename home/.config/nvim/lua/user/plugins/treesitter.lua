return {
    "nvim-treesitter",
    dependencies = {
        "HiPhish/nvim-ts-rainbow2",
        "andymass/vim-matchup",
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
        },
        matchup = {
            enable = true,
        }
    }
}
