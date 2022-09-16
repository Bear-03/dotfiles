#!/bin/nu

let step = 10
let min = 1

def main [op: string] {
    do ({
        up: { up }
        down: { down }
    } | get $op)
}

def up [] {
    let percent = brightness-percent

    if $percent < $step {
        brightnessctl -q s 1%+
    } else {
        brightnessctl -q s $"($step)%+"
    }
}

def down [] {
    let percent = brightness-percent
    if $percent <= $step {
        # Don't let brightness get to 0 (screen goes black)
        let new_value = ([($percent - 1) $min] | math max)

        brightnessctl -q s $"($new_value)%"
    } else {
        brightnessctl -q s $"($step)%-"
    }
}

def brightness-percent [] {
    (brightnessctl g | into int) / (brightnessctl m | into int) * 100
    | math round
}
