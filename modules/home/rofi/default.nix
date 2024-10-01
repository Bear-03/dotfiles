{ namespace, config, lib, pkgs, ... }:
with lib;
let
    cfg = config.${namespace}.rofi;
in
{
    options.${namespace}.rofi = {
        enable = mkEnableOption "Rofi";
    };

    config = mkIf cfg.enable {
        programs.rofi.enable = true;

        home.file.".config/rofi" = {
            source = ./config;
            recursive = true;
        };
    };
}