{ host-dir, hostname, usernames, flake-root, pkgs, ... } @ inputs:
{
    users.users = builtins.listToAttrs (map (username: {
        name = username;
        value = import (host-dir + /users/${username}/user.nix) username inputs;
    }) usernames);
}