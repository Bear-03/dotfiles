{ config, lib, pkgs, flakeRoot, ... } @ args:
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

    config = let
        argsExt = username: args // { inherit username; };
    in
    mkIf cfg.enable {
        users.users = mapFilesToAttrs {
            dir = cfg.dir;
            valueFn = username: import (cfg.dir + /${username}) (argsExt username);
        };

        home-manager.users = mapFilesToAttrs {
            dir = cfg.dir;
            valueFn = username: let
                homePath = cfg.dir + /${username}/home;
            in
            # If it isn't present, add null as placeholder, will be filtered out later
            if builtins.pathExists homePath
            then (args: {
                imports = [ homePath ];
                _module.args = (argsExt username);
            })
            else null;
        };
    };
}