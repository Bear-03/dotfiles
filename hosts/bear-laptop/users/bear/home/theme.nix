# Fonts, visuals...
{ pkgs, ... }:
{
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
        (nerdfonts.override {
            fonts = [
                "JetBrainsMono"
                "FiraCode"
            ];
        })
    ];
}