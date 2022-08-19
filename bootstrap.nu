#!/bin/nu

def to [
    name: string
    --home: bool
] {
    echo $"($env.HOME)/(if $home { '' } else { '.config/' })($name)"
}

def from [
    name: string
    --home: bool
] {
    echo $"./(if $home { '' } else { '.config/' })($name)"
}

def prompt [name: string, body: block] {
    echo $"($name)..."
    do $body
    echo "DONE"
}

def link [...argv: any] {
    let argv = (if ($argv.0 | path type) == dir {
        mkdir $argv.1
        $argv | update 0 $"($argv.0)/*"
    } else {
        $argv
    })

    ln -rns $argv
}


prompt ".profile" {
    link (from ".profile" --home) (to ".profile" --home)
}

prompt ".gitconfig" {
    link (from ".gitconfig" --home) (to ".gitconfig" --home)
}

prompt "Nushell" {
    # nushell/history.txt has to be created so it
    # is not possible to link the whole folder
    link (from "nushell") (to "nushell")
}

prompt "Paru" {
    link (from "paru") (to "paru")
}

prompt "River" {
    link (from "river") (to "river")
}

prompt "Waybar" {
    link (from "waybar") (to "waybar")
}

prompt "Wofi" {
    link (from "wofi") (to "wofi")
}

prompt "Alacritty" {
    link (from "alacritty") (to "alacritty")
}

prompt "Neovim (AstroNvim)" {
    git clone https://github.com/AstroNvim/AstroNvim (to "nvim")
    link (from "astronvim") (to "nvim/lua/user") 
}
