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

def download [url: string] {
    cd (xdg-user-dir DOWNLOAD)
    curl $url -O
    cd -
}

# Pacman autoremove (Remove orphan packages)
def pacman-au [] {
    let orphans = (sudo pacman -Qdtq | split row "\n")

    if ($orphans | is-empty) {
        print "Nothing to uninstall"
    } else {
        $orphans | each { |it|
            print $"Uninstalling ($it)..."
            sudo pacman -Rns --noconfirm $it | ignore
        }
    }
}

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

def javarun [class: string] {
    print "Compiling..."
    javac $"($class).java"
    java $class
}

def mnt [name: string] {
    let mnt_dir = $"/mnt/($name)"
    mkdir $mnt_dir
    mount $"/dev/($name)" $mnt_dir
}

def umnt [name: string] {
    umount $"/dev/($name)"
    rm -r $"/mnt/($name)"
}

# Starship setup
source ~/.cache/starship/init.nu

