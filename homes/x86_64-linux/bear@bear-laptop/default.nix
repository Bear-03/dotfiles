{ config, pkgs, ... }:
{
    imports = [
        ./git.nix
        ./udiskie.nix
        ./flatpak.nix
        ./firefox.nix
    ];

    home = {
        packages = with pkgs; [
            vim
            lxqt.lxqt-policykit # Polkit support
            neofetch
            xorg.xlsclients # List all windows using XWayland
            pavucontrol # Audio controller
            vesktop # Third-party discord client with screensharing
            telegram-desktop
            trash-cli # Trashcan management
            p7zip # 7zip tools
            zip
            unzip
            zstd # .zst file management, for building some types of nixos images
            nixos-generators # NixOS image builder helper
            gcc-unwrapped
            qbittorrent
            vlc
            jellyfin-media-player
        ];

        sessionVariables = {
            EDITOR = "code";
            VISUAL = "code";
        };

        stateVersion = "24.05";
    };

    programs = {
        vscode.enable = true;
        home-manager.enable = true;
        bottom.enable = true;
    };

    internal = {
        nushell.enable = true;
        alacritty.enable = true;
        ags.enable = true;
        theme.enable = true;
        hyprland = {
            enable = true;
            wallpaper = ./bg.png;
        };
    };
}
