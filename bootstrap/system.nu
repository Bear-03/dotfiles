#!/bin/nu

# Set up things outside of $HOME (/etc, /boot...)

# Install rust
do {
    if (rustup toolchain list | str trim) == "no installed toolchains" {
        print "Installing Rust"
        rustup toolchain install nightly
    } else {
        print "Rust already installed, skipping"
    }
}

# Change kernel parameters
do {
    print "Changing kernel parameters"

    let new_params = [
         # Fixes SMBus error on login
        "modprobe.blacklist=i2c_i801"
        # Fixes VirtualBox being stuck at loading 20%
        "ibt=off"
        # Removes non-important kernel errors from showing in LY DM and TTY
        "quiet"
    ]

    ls "/boot/loader/entries" | each { |file|
        print $"Changing entry ($file.name)"
        $new_params | reduce -f (open $file.name) { |param, contents| 
            if $contents =~ $param {
                print $"Parameter ($param) already set, skipping"
                $contents
            } else {
                print $"Adding parameter ($param)"
                $contents
                # Keep all existing params, just append the new one
                | str replace "(options .+)" $"$1 ($param)"
            }
        }
        | save -f $file.name
    }
}

# Stop bluetooth from turning on automatically
do {
    print "Turning bluetooth AutoEnable off"

    let file = "/etc/bluetooth/main.conf"

    open $file
    | str replace "#AutoEnable=true" "AutoEnable=false"
    | save $file -f
}

