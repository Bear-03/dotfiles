{ config, lib, pkgs, flakeRoot, hostDir, ... } @ args:
with lib;
let
    mapFilesToAttrs = import (flakeRoot + /utils/map-files-to-attrs.nix) pkgs.lib;
    cfg = config.modules.users;
in
{
    options.modules.users = {
        enable = mkEnableOption "NixOS file-based configuration";
        dir = mkOption {
            type = types.path;
            description = ''
                Path to the directory to fetch the users from.
            '';
        };
    };

    config = mkIf cfg.enable {
        users.users = mapFilesToAttrs {
            dir = cfg.dir;
            valueFn = username: import (cfg.dir + /${username}/user.nix) (args // { inherit username; });
        };
    };
}