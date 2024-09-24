{ hostDir, hostname, flakeRoot, pkgs, ... } @ inputs: let
    inherit (import (flakeRoot + /utils/functions.nix) pkgs.lib) mapFilesToAttrs;
    usersDir = hostDir + /users;
in
{
    users.users = mapFilesToAttrs {
        dir = usersDir;
        valueFn = username: import (usersDir + /${username}/user.nix) username inputs;
    };
}