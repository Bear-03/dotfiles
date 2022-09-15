#!/bin/nu

let station = "wlan0"

# Removes color codes from input string
def remove-color [] {
    $in | str replace `\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]` "" --all
}

# Retuns a list of networks (table)
# A network is a record of the form
# {
#     connected: bool,
#     ssid: string,
#     security: string,
# }
def networks [] {
    iwctl station $station get-networks
    | tail -n +5
    | head -n -1
    | remove-color
    | split row "\n"
    | each { |it|
        $it
        | parse -r `\s{2}(?P<connected>[> ])\s{3}(?P<ssid>.+)\s+(?P<security>[a-zA-Z0-9]+)\s{17}\**\s{4}`
        | update connected { |x| $x.connected == ">" }
        | update ssid { |x| $x.ssid | str trim }
    }
    | flatten
}


# network is a record of the form
# {
#     connected: bool,
#     ssid: string,
#     security: string,
# }
def network-into-string [network] {
    let connected = (if $network.connected {
        ">"
    } else {
        " "
    })

    let security = (if ($network.security | is-empty) == false {
        ""
    } else {
        ""
    })

    $"($security) ($connected) ($network.ssid)"
}

def connect [ssid: string] {
    if (iwctl known-networks list) =~ $ssid {
        iwctl station $station connect $ssid
    } else {
        let passphrase = (rofi -dmenu -l 0 -password -p "Passphrase: " | str trim)
        iwctl station $station connect $ssid --passphrase $passphrase
    }
}

def scan [] {
    iwctl station $station scan
    sleep 3sec
}

def show-menu [] {
    let exit_title = "Exit"

    # option representation -> block record, used to access
    # the code that has to be run for a given option
    let options = (
        networks
        # Each network record will be converted into a name->block record
        # and all of them will be merged together with reduce
        | reduce -f {} { |it, acc|
            $acc | merge {{
                (network-into-string $it): {
                    connect $it.ssid
                    exit 0
                }
            }}
        }
        | merge {{
            "": {;}
            "Scan": { scan }
            $exit_title: { exit 0 }
        }}
    )

    let selected_str = (
        $options
        | columns
        | str collect "\n"
        | rofi -dmenu -selected-row 0 -p "SSID: "
    )

    if ($selected_str | is-empty) {
        # Last option is considered exit
        $options | get $exit_title
    } else {
        $options | get ($selected_str | str trim)
    }
}

0.. | each {
    do (show-menu)
}

