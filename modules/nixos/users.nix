{ hostname, usernames, flakeRoot, pkgs, ... } @ inputs:
{
    users.users = builtins.listToAttrs (map (username: {
        name = username;
        value = import (flakeRoot + /hosts/${hostname}/users/${username}/user-configuration.nix) username inputs;
    }) usernames);
}