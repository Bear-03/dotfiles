#!/bin/nu

use ./util.nu [mapped-get eww-update-record]

let step = 10

def main [percent?: int] {
    let percent = if $percent == null {
        percent
    } else {
        $percent
    }

    let icons = ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"]

    let info = {
        icon: ($icons | mapped-get $percent 1 100),
        percent: $percent,
    }

    eww-update-record "brightness" $info
}

def "main up" [] {
    let old_percent = (percent)

    let new_percent = (if $old_percent < $step {
        $old_percent + 1
    } else {
        $old_percent + $step
    }
    # Clamp value
    | append 100
    | math min)

    brightnessctl -q s $"($new_percent)%"
    main $new_percent
}

def "main down" [] {
    let old_percent = (percent)

    let new_percent = (if $old_percent <= $step {
        $old_percent - 1
    } else {
        $old_percent - $step
    }
    # Don't let brightness get to 0 (screen goes black)
    | append 1
    | math max)

    brightnessctl -q s $"($new_percent)%"
    main $new_percent
}

def percent [] {
    (brightnessctl g | into int) / (brightnessctl m | into int) * 100
    | math round
}
