#!/bin/nu

use ./util.nu hypr-listen

let max_workspaces = 5;

def main [] {
    handle-event 1
    hypr-listen "workspace" { |data| handle-event ($data | into int) }
}

def "main change" [id: int] {
    hyprctl dispatch workspace $id
}

def handle-event [id: int] {
    print ({
        id: $id,
        is_unknown: (not $id in 1..$max_workspaces)
    } | to json --raw)
}
