{ namespace, config, lib, pkgs, ... }:
with lib;
let
    cfg = config.${namespace}.users;
in
{
    options.${namespace}.users = mkOption {
        description = "User config";
        type = types.attrs;
    };

    config.users.users = mapAttrs (_: value: {
        isNormalUser = true;
        shell = pkgs.nushell;
    } // value) cfg;
}