#!/bin/nu

use ./util.nu eww-update-record

def main [] {
    let powered_output = (bluetoothctl show | parse -r 'Powered: (\w+)').capture0.0
    let connection_output = (bluetoothctl info
                             | lines
                             | str trim
                             | split column ": "
                             | range 1..
                             | transpose --header-row --as-record)

    let powered = ($powered_output == "yes")
    let connected = (($connection_output | get -i "Connected") == "yes")

    let alias_raw = ($connection_output | get -i "Alias")
    let alias = if ($alias_raw | is-empty) {
        null
    } else {
        $alias_raw
    }

    let info = {
        powered: $powered,
        connected: $connected,
        alias: $alias,
        icon: (icon $powered $connected)
    }

    $info | to json --raw
}

def icon [powered: bool, connected: bool] {
    let icons = {
        off: "󰂲",
        on: "󰂯",
        connected: "󰂱",
    }

    if not $powered {
        $icons.off
    } else if not $connected {
        $icons.on
    } else {
        $icons.connected
    }
}