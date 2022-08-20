return {
    filesystem = {
        group_empty_dirs = true,
        filtered_items = {
            hide_dotfiles = false,
            hide_by_name = {
                ".git",
                ".DS_Store",

                -- Js
                "node_modules",
                "package-lock.json",
                ".next",

                -- Pythong
                "__pycache__",
                ".venv",

                -- Rust
                "target",
                "Cargo.lock",
            },
            hide_by_pattern = {
                "^.*\\.o$",
                "^.*\\.import$",
                "^.*\\.mono$"
            }
        },
    },
}
