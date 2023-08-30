#!/bin/nu

use ../global/util.nu [hypr-listen str-ellipsis]

let title_max_length = 60;
let ellipsis = "...";

def main [] {
    hypr-listen "activewindow" { |data|
        print (($data | parse "{program},{title}").title.0 | str-ellipsis 60)
    }
}