{ hostname, usernames, flakeRoot, pkgs, ... } @ inputs:
{
    users = {
        groups = builtins.listToAttrs (map (username: {
            name = username;
            value = {};
        }) usernames);
        users = builtins.listToAttrs (map (username: {
            name = username;
            value = import (flakeRoot + /hosts/${hostname}/users/${username}/user-configuration.nix) username inputs // {
                # Without this NixOS spits out an error when installing
                # https://github.com/NixOS/nixpkgs/blob/090bc11bc054f5f9745cfbcf058f9ad9a39e51c7/nixos/modules/config/users-groups.nix#L918
                group = username;
            };
        }) usernames);
    };
}