#!/bin/nu

use ./util.nu [mapped-get eww-update-record]

let volume_step = 5

def main [] {
    # Audio sink is not ready just after boot
    # pamixer will error if anything about the sink
    # is accessed before it is ready
    while (do {
        pamixer --get-default-sink
        $env.LAST_EXIT_CODE != 0 # Repeat if it failed
    }) {
        sleep 1sec
    }

    let volume = (pamixer --get-volume | into int)
    let muted = (pamixer --get-mute | into bool)

    let info = {
        muted: $muted
        volume: $volume
        icon: (icon $muted $volume)
    }

    eww-update-record "speaker" $info
}

def "main up" [] {
    pamixer -i $volume_step
    main
}

def "main down" [] {
    pamixer -d $volume_step
    main
}

def "main mute" [] {
    pamixer --toggle-mute
    main
}

def icon [muted: bool, volume: int] {
    let icons = {
        off: "󰝟"
        on: ["󰕿", "󰖀", "󰕾"],
    }

    if $muted {
        return $icons.off
    }

    $icons.on | mapped-get $volume 0 100
}