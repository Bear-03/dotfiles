#!/bin/nu

# Create the config symlinks

def link [...argv: any] {
    ^mkdir -p ($argv.1 | path dirname)
    ln -rns $argv
}

# "to" gets the destination dir from the origin
def link-dir [from_dir: string, to_dir: string] {
    # Add trailing / if not present
    let to_dir = $to_dir + (if ($to_dir | str ends-with "/") { "" } else { "/" })

    cd $from_dir

    (ls -la "./**/*" | where type == file).name
    | each { |from_file|
        let to_file = $to_dir + $from_file

        print $"($to_file)..."
        link $from_file $to_file
        print "DONE";
    }

    cd -
}

let home = $"/home/(logname | str trim)"

# Clone AstroNvim
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
link-dir "home" $home
link-dir "etc" "/etc"

