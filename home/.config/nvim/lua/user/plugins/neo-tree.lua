return {
    "neo-tree.nvim",
    opts = {
        close_if_last_window = true,
        default_component_configs = {
            indent = {
                with_markers = false,
            },
        },
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

                    -- Python
                    "__pycache__",
                    ".venv",

                    -- Rust
                    "target",
                    "Cargo.lock",
                },
                hide_by_pattern = {
                    "*.o",
                    "*.import",
                    "*.mono",
                    "*.class",
                }
            },
        },
    }
}
