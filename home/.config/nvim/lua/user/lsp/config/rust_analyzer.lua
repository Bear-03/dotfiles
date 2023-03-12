return {
    settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true, },
            diagnostics = {
                disabled = { "inactive-code" },
            },
            checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
        }
    }
}
