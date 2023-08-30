#!/bin/nu

def main [] {
    eww daemon
    init
}

def "main reload" [] {
    eww reload
    init
}

def init [] {
    cd $env.SCRIPTS

    ./speaker.nu
    ./brightness.nu

    eww open statusbar
}
