# Listens to socket events emmited from hyprland
export def hypr-listen [event_name: string, on_event: closure] {
    socat -u $"UNIX-CONNECT:/tmp/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock" -
    | lines
    | parse "{name}>>{data}"
    | where name == $event_name
    | each { |it|
        do $on_event ($it | get data)
    }
}

# Updates an eww JSON variable from a NU record
export def eww-update-record [var_name: string, record: record] {
    eww update $"($var_name)=($record | to json --raw)"
}

# Gets an element from a collection, mapping the index
# from one range to the range of valid collection indices (0..<len)
export def mapped-get [index: int, low: int, high: int] {
    $in | get (map ($index | clamp $low $high) $low $high 0 (($in | length) - 1) | math round)
}

# Clamps values between a range
export def clamp [low: int, high: int] {
    $in | each { |it|
        if $it < $low {
            $low
        } else if $in > $high {
            $high
        } else {
            $it
        }
    }
}

# Maps a value from one range to another
export def map [value: int, from_low: int, from_high: int, to_low: int, to_high: int] {
    let conversion_rate = ($to_high - $to_low) / ($from_high - $from_low)
    $to_low + $conversion_rate * ($value - $from_low)
}

# Trims a string if it is too long and replaces the last characters with an ellipsis
export def str-ellipsis [max_length: int, ellipsis?: string = "..."] {
    if (($in | str length) > $max_length) {
        let cut_length = $max_length - ($ellipsis | str length)
        ($in | str substring 0..$cut_length) + $ellipsis
    } else {
        $in
    }
}