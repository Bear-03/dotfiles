# Fonts, visuals...
{ namespace, config, lib, pkgs, ... }:
with lib;
let
    cfg = config.${namespace}.theme;
in
{
    options.${namespace}.theme = {
        enable = mkEnableOption "Theme configuration";
    };

    config = mkIf cfg.enable {
        gtk = {
            enable = true;
            theme = {
                name = "adw-gtk3-dark";
                package = pkgs.adw-gtk3;
            };
        };

        qt = {
            enable = true;
            platformTheme.name = "adwaita";
            style.name = "adwaita-dark";
        };

        home.packages = with pkgs; [
            adw-gtk3 # Adwaita theme for gtk
            adwaita-icon-theme # Cursor theme
            nerd-fonts.jetbrains-mono
            nerd-fonts.fira-code
        ];
    };
}