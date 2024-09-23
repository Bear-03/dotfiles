{ pkgs, ags, ... } @ inputs:
{
    imports = [
        ags.homeManagerModules.default
    ];

    programs.ags = {
        enable = true;
        configDir = ../ags;
        extraPackages = with pkgs; [
            gtksourceview
            webkitgtk
            accountsservice
        ];
    };
}