let-env config = {
    show_banner: false,
    edit_mode: vi
}

alias la = ls -la
alias grep = rg
alias cat = bat

def download [url: string] {
    cd (xdg-user-dir DOWNLOAD)
    curl $url -O
    cd -
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

