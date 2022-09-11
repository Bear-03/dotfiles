#!/bin/nu

# Create the config symlinks

def link [...argv: any] {
    ^mkdir -p ($argv.1 | path dirname)
    ln -rns $argv
}

let home = $"/home/(logname | str trim)"

do {
    let nvim_cfg_path = $"($home)/.config/nvim"

    if (ls $nvim_cfg_path | is-empty) {
        git clone "https://github.com/AstroNvim/AstroNvim" $nvim_cfg_path
    } else {
        print $"Cloning AstroNvim was skipped, ($nvim_cfg_path) was not empty"
    }
}

# Symlink files individually instead of folders
# so programs can create new files in those folders
# without them being committed automatically
(ls -la "home/**/*" | where type == file).name
| each { |from|
    let to = ($from | str replace "home" $home)

    print $"($from)..."
    link $from $to
    print "DONE";
}

