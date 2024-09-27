{ config, lib, pkgs, flakeRoot, ... } @ args:
with lib;
let
    mapFilesToAttrs = import (flakeRoot + /utils/map-files-to-attrs.nix) pkgs.lib;
    cfg = config.modules.users;
    usersDir = hostDir + /users;
in
{
    options.modules.users = {
        enable = mkEnableOption "NixOS file-based configuration";
        hostDir = mkOption {
            type = types.path;
            description = ''
                Path to the directory of the host to fetch the users from.
            '';
        };
    };

    config = mkIf cfg.enable {
        users.users = let
            usersDir = cfg.hostDir + /users;
        in
        mapFilesToAttrs {
            dir = usersDir;
            valueFn = username: import (usersDir + /${username}/user.nix) username args;
        };
    };
}