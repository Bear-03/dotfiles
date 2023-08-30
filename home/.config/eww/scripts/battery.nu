#!/bin/nu

use ../global/util.nu [mapped-get, eww-update-record]

def main [] {
    let percent = (get-info "capacity" | into int)
    let status = (get-info "status" | str trim)

    let info = {
        percent: $percent,
        icon: (icon $status $percent)
    }

    $info | to json --raw
}

def icon [status: string, percent: int] {
    let icons = {
        charging: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
        discharging: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    }

    let list = if $status == "Discharging" {
        $icons.discharging
    } else { # Charging and Full
        $icons.charging
    }

    $list | mapped-get $percent 0 100
}

def get-info [file: string] {
    open $"/sys/class/power_supply/BAT0/($file)"
}
