#!/bin/nu

# Set up things outside of $HOME (/etc, /boot...)

# Blacklist i2c_i801 module (Fixes SMBus error on login)
do {
    echo "Blacklisting i2c_i801 kernel module"

    let file = (
        ls "/boot/loader/entries"
        | get 0
    ).name

    let kernel_arg = "modprobe.blacklist=i2c_i801"
    let file_contents = open $file

    if ($file_contents =~ $kernel_arg) == false {
        $file_contents
        | str replace "(options .+)" $"$1 ($kernel_arg)"
        | save $file
    }
}

# Stop bluetooth from turning on automatically
do {
    echo "Turning bluetooth AutoEnable off"

    let file = "/etc/bluetooth/main.conf"

    open $file
    | str replace "#AutoEnable=true" "AutoEnable=false"
    | save $file
}
