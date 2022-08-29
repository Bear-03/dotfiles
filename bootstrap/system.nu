#!/bin/nu

# Set up things outside of $HOME (/etc, /boot...)

# Blacklist i2c_i801 module (Fixes SMBus error on login)
do {
    echo "Blacklisting i2c_i801 kernel module"

    let path = (
        ls "/boot/loader/entries"
        | get 0
    ).name

    open $path
    | str replace "(options .+)" "$1 modprobe.blacklist=i2c_i801"
    | save $path
}

# Stop bluetooth from turning on automatically
do {
    echo "Turning bluetooth AutoEnable off"

    let path = "/etc/bluetooth/main.conf"

    open $path
    | str replace "#AutoEnable=true" "AutoEnable=false"
    | save $path
}
