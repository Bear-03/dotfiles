{ namespace, config, lib, pkgs, inputs, ... }:
with lib;
let
    inherit (inputs) ags;

    cfg = config.${namespace}.ags;
in
{
    imports = [
        ags.homeManagerModules.default
    ];

    options.${namespace}.ags = {
        enable = mkEnableOption "Ags widgets configuration";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            brightnessctl # Brightness control
            sassc # SCSS compiler
        ];

        programs.ags = {
            enable = true;
            configDir = ./config;
            extraPackages = with pkgs; [
                gtksourceview
                webkitgtk
                accountsservice
            ];
        };
    };
}