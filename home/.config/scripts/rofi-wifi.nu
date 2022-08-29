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
#     signal: int
# }
def networks [] {
    iwctl station $station get-networks
    | tail -n +5
    | head -n -1
    | remove-color
    | split row "\n"
    | each { |it|
        $it
        | parse -r `\s{2}(?P<connected>[> ])\s{3}(?P<ssid>.+)\s+(?P<security>[a-zA-Z0-9]+)\s{17}(?P<signal>\**)\s{4}`
        | update connected { |x| $x.connected == ">" }
        | update ssid { |x| $x.ssid | str trim }
        | update signal { |x| $x.signal | str length }
    }
    | flatten
}


# network is a record of the form
# {
#     connected: bool,
#     ssid: string,
#     security: string,
#     signal: int
# }
def network-into-string [network] {
    let connected = (if $network.connected {
        ">"
    } else {
        " "
    })

    let security = (if ($network.security | empty?) == false {
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
        let passphrase = (rofi -dmenu -password -p "Passphrase: " | str trim)
        iwctl station $station connect $ssid --passphrase $passphrase
    }
}

def scan [] {
    iwctl station $station scan
    sleep 3sec
}

def show-menu [] {
    let networks = networks

    let options = (
        $networks
        | sort-by -r signal
        | each { |it|
            {
                text: (network-into-string $it)
                block: { connect $it.ssid }
            }
        }
        | append {
            text: "",
            block: {;}
        }
        | append {
            text: "Scan",
            block: { scan }
        }
        | append {
            text: "Exit",
            block: { exit 0 }
        }
    )

    let selected_str = (
        $options.text
        | str collect "\n"
        | rofi -dmenu -selected-row 0 -p "SSID: "
    )

    if ($selected_str | empty?) {
        $nothing
    } else {
        $options
        | find -p { |option|
            $option.text == ($selected_str | str trim)
        }
        | get 0
    }
}

0.. | each {
    let selection = show-menu

    if $selection == $nothing {
        print "No selection, exiting..."
        exit 0
    }

    do $selection.block
}

