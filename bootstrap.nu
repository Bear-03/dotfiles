#!/bin/nu

def link [...argv: any] {
    ^mkdir -p ($argv.1 | path dirname)
    ln -rns $argv
}

git clone "https://github.com/AstroNvim/AstroNvim" "~/.config/nvim"

# Symlink files individually instead of folders
# so programs can create new files in those folders
# without them being committed automatically
(ls -la "home/**/*" | where type == file).name
| each { |from|
    let to = ($from | str replace "home" "~")

    print $"($from)..."
    link $from $to
    print "DONE";
}

