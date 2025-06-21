$env.config = {
    show_banner: false,
    edit_mode: vi,
    table: {
        mode: light,
    },
    display_errors: {
        exit_code: false
        termination_signal: true
    }
}

$env.SHELL = $nu.current-exe

alias la = ls -la
alias grep = rg
alias cat = bat
alias tree = broot

# Create and activate python venv
def pyvenv [
    env_path: string = ".venv",
    --version (-v): string
] {
    let python_cmd = $"python($version)"

    if (not ($env_path | path exists)) {
        let version = (nu -c $"($python_cmd) -V")
        print $"Creating environment '($env_path)' with ($version)..."
        nu -c $"($python_cmd) -m venv ($env_path)"
    }

    print $"Activating environment '($env_path)'... \(Deactivate with Ctrl-D\)"
    bash -c $"source ($env_path)/bin/activate && nu"
}

def --wrapped nr [
    --mode: string = "switch",
    --flake: string = "path:.",
    ...rest,
] {
    nixos-rebuild $mode --flake $flake --use-remote-sudo ...$rest
}