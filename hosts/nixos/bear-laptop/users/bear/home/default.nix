username: { config, pkgs, flakeRoot, ... }:
{
    imports = [
        ./git.nix
        ./udiskie.nix
        ./flatpak.nix
    ];

    home = {
        inherit username;
        homeDirectory = "/home/${username}";

        packages = with pkgs; [
            vim
            rofi
            firefox
        ];

        sessionVariables = {
            TERM = "alacritty";
            EDITOR = "code";
            VISUAL = "code";
            BROWSER = "firefox";
        };

        file.".config/rofi" = {
            source = ../rofi;
            recursive = true;
        };

        stateVersion = "24.05";
    };

    programs = {
        vscode.enable = true;
        home-manager.enable = true;
        rofi.enable = true;
        bottom.enable = true;
    };

    modules = {
        nushell.enable = true;
        alacritty.enable = true;
        ags.enable = true;
        theme.enable = true;
        hyprland = {
            enable = true;
            wallpaper = ../bg.png;
        };
    };
}
