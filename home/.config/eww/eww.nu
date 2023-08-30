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
    cd $env.FILE_PWD

    scripts/speaker.nu eww-update
    scripts/brightness.nu eww-update

    eww open statusbar
}
