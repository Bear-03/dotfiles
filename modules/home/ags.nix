{ config, lib, pkgs, inputs, ... }:
with lib;
let
    inherit (inputs) ags;

    cfg = config.modules.ags;
in
{
    imports = [
        ags.homeManagerModules.default
    ];

    options.modules.ags = {
        enable = mkEnableOption "Ags widgets configuration";
    };

    config = mkIf cfg.enable {
        programs.ags = {
            enable = true;
            configDir = ../ags;
            extraPackages = with pkgs; [
                gtksourceview
                webkitgtk
                accountsservice
            ];
        };
    };
}