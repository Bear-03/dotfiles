#!/bin/nu

use ../global/util.nu [mapped-get eww-update-record str-ellipsis]

def main [] {
    let output = (iwctl station wlan0 show
                    | lines
                    | split column -r '\s{2,}'
                    | range 4..<-1 # Last row is always empty
                    | reject column1 column4 # These are also always empty
                    | transpose --header-row --as-record)

    # When the station is disconnected, some captures
    # will be missing, so "get -i" has to be used
    let connected = ($output.State == "connected")
    # This is still a string, as it can be null if the station is not connected
    let rssi = (($output | get -i "RSSI" | parse "{rssi} dBm").rssi | get -i 0)

    let info = {
        scanning: ($output.Scanning == "yes"),
        connected: $connected,
        ssid: ($output | get -i "Connected network" | str-ellipsis 15),
        ip: ($output | get -i "IPv4 address"),
        icon: (icon $connected $rssi),
    }

    $info | to json --raw
}

def icon [connected: bool, rssi_raw: string] {
    let icons = {
        on: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
        off: "󰤮",
    }

    if not $connected {
        return $icons.off
    }

    # We know $rssi_raw is not null if the station
    # is connected, so it is safe to convert it to int
    $icons.on | mapped-get ($rssi_raw | into int) -100 -50
}