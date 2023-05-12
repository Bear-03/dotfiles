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

    let file = (ls "/boot/loader/entries" | get 0).name

    # Fixes SMBus error on login
    let kernel_arg = "modprobe.blacklist=i2c_i801"
    # Fixes VirtualBox being stuck at loading 20%
    let ibt_arg = "ibt=off"
    # Removes non-important kernel errors from showing in LY DM and TTY
    let quiet_arg = "quiet"

    let file_contents = (open $file)
    if ($file_contents =~ $kernel_arg) == false {
        $file_contents
        | str replace "(options .+)" $"$1 ($kernel_arg)"
        | save -f $file
    }

    let file_contents = (open $file)
    if ($file_contents =~ $ibt_arg) == false {
        $file_contents
        | str replace "(options .+)" $"$1 ($ibt_arg)"
        | save -f $file
    }


    let file_contents = (open $file)
    if ($file_contents =~ $quiet_arg) == false {
        $file_contents
        | str replace "(options .+)" $"$1 ($quiet_arg)"
        | save -f $file
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

