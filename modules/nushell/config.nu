$env.config = {
    show_banner: false,
    edit_mode: vi,
    table: {
        mode: light,
    },
}

alias la = ls -la
alias grep = rg
alias cat = bat
alias tree = broot

# Create and activate python venv
def pyvenv [
    env_path?: string,
    --version (-v): string
] {
    let env_path = if ($env_path == null) {
        ".venv"
    } else {
        $env_path
    }

    let python_cmd = $"python($version)"

    if (not ($env_path | path exists)) {
        let version = (nu -c $"($python_cmd) -V")
        print $"Creating environment '($env_path)' with ($version)..."
        nu -c $"($python_cmd) -m venv ($env_path)"
    }

    print $"Activating environment '($env_path)'... \(Deactivate with Ctrl-D\)"
    bash -c $"source ($env_path)/bin/activate && nu"
}
