#!/bin/nu

if (whoami | str trim) != "root" {
    echo "Please run the bootstrap script as root"
    exit 1
}

source "bootstrap/system.nu"
source "bootstrap/symlink.nu"
