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

# Blacklist i2c_i801 module (Fixes SMBus error on login)
do {
    print "Blacklisting i2c_i801 kernel module"

    let file = (ls "/boot/loader/entries" | get 0).name
    let file_contents = open $file

    let kernel_arg = "modprobe.blacklist=i2c_i801"

    if ($file_contents =~ $kernel_arg) == false {
        $file_contents
        | str replace "(options .+)" $"$1 ($kernel_arg)"
        | save $file
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

# Enable system modules
do {
    # TLP
    systemctl enable tlp
    systemctl mask systemd-rfkill.service systemd-rfkill.socket
}

